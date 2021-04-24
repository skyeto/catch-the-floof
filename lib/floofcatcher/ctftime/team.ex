defmodule Floofcatcher.Ctftime.Team do
  defstruct [
    :id,
    :name,
    :description,
    :country,
    :academic,
    :logo
  ]

  @type t :: %__MODULE__{
    id: integer,
    name: String.t(),
    description: String.t() | nil,
    country: String.t() | nil,
    academic: boolean,
    logo: String.t() | nil
  }

  # {"img", [{"src", "/static/images/f/se.png"}, {"alt", "SE"}], []},

  def logo_from_html(doc) do
    case Floki.find(doc, ".container .row .span2 img") do
      [{"img", [
        {"src", uri},
        _, _
      ], _}] ->
        Floofcatcher.Ctftime.Api.url() <> uri
      _ ->
        nil
    end
  end

  def description_from_html(doc) do
    case Floki.find(doc, ".container .row .span12 .well") do
      [{"div", _, content}] ->
        content
        |> Enum.map(fn {_, _, text} -> text end)
        |> Enum.join(" \n ")
      _ ->
        nil
    end
  end

  def name_from_html(doc) do
    {name, _} = name_country_from_html(doc)
    name
  end

  def country_from_html(doc) do
    {_, country} = name_country_from_html(doc)
    country
  end

  defp name_country_from_html(doc) do
    case Floki.find(doc, ".container .page-header h2") do
      [{"h2", _, [
        {"img", [_, {"alt", country}], _},
        name
      ]}] -> {String.trim(name), country}
      [{"h2", _, [
        name
      ]}] -> {String.trim(name), nil}
    end
  end
end
