defmodule Floofcatcher.Ctftime.Team do
  defstruct [
    :id,
    :name,
    :description,
    :country,
    :academic,
    :logo
  ]

  @type id :: integer
  @type name :: String.t()
  @type description :: String.t() | nil
  @type country :: String.t() | nil
  @type academic :: boolean
  @type logo :: String.t() | nil

  # {"img", [{"src", "/static/images/f/se.png"}, {"alt", "SE"}], []},

  def name_from_html(doc) do
    case Floki.find(doc, ".page-header h2") do
      [{"h2", _, [
        {"img", _, _},
        name
      ]}] -> name
      [{"h2", _, [
        name
      ]}] -> String.trim(name)
    end
  end
end
