defmodule Floofcatcher.Ctftime.Api do
  @ctftime "https://ctftime.org"
  @ctftime_api @ctftime <> "/api/v1"

  require Logger

  def get_team(id) do
    # TODO: We can't use the API endpoint since it doesn't return
    # the description. :(
    with  {:ok, body} <- get_request(@ctftime, ["team", id]),
          {:ok, doc} <- Floki.parse_document(body)
    do
      # TODO: Set academic
      {:ok, %Floofcatcher.Ctftime.Team{
        id: String.to_integer(id),
        name: Floofcatcher.Ctftime.Team.name_from_html(doc),
        country: Floofcatcher.Ctftime.Team.country_from_html(doc),
        description: Floofcatcher.Ctftime.Team.description_from_html(doc),
        logo: Floofcatcher.Ctftime.Team.logo_from_html(doc)
      }}
    else
      _ -> {:error, "team not found"} # TODO: Error checking (e.g. 500 from ctftime)
    end
  end

  def get_event(id) do
    with  {:ok, body} <- get_request(@ctftime_api, ["events", id, ""]),
          {:ok, event} <- Jason.decode(body)
    do
      IO.inspect(body)
      IO.inspect(event)
      {:ok, %Floofcatcher.Ctftime.Event{
        ctf_id: event["id"],
        title: event["title"],
        url: event["url"],
        restrictions: event["restrictions"],
        format: event["format"],
        ctftime_url: event["ctftime_url"],
        onsite: event["onsite"],
        location: event["location"],
        start: event["start"],
        duration: event["duration"],
        weight: event["weight"]
      }}
    else
      _ -> {:error, "event not found"} # TODO: Error checking (e.g. 500 from ctftime)
    end

  end

  def url, do: @ctftime

  defp get_request(endpoint, args) do
    result = build_url(endpoint, args) |> HTTPoison.get
    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      _ ->
        :error
    end
  end

  defp build_url(endpoint, args) do
    endpoint <> "/" <> Enum.join(args, "/")
  end
end
