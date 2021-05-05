defmodule Floofcatcher.Discord.Helper.Event do
  alias Floofcatcher.{
    Repo,
    Event
  }

  @spec get_or_create_event(integer) :: {:ok, Floofcatcher.Event.__struct__} | {:error, String.t}
  def get_or_create_event(event_id) do
    case Repo.get_by(Event, event_id: event_id) do
      nil ->
        Floofcatcher.Ctftime.Api.get_event(event_id)
        |> create_event()
      event ->
        {:ok, event}
    end
  end

  @spec create_event({:ok, Floofcatcher.Ctftime.Event.t} | {:error, String.t}) :: {:ok, Floofcatcher.Event.__struct__} | {:error, String.t}
  defp create_event(error = {:error, _}), do: error
  defp create_event({:ok, event}) do
    changeset = Event.changeset(%Event{}, %{
      ctf_id: event.ctf_id,
      ctftime_url: event.url,
      duration: 10, #TODO: Calculate time
      event_id: event.id,
      format: event.format,
      location: event.location,
      onsite: event.onsite,
      restrictions: event.restrictions,
      start: event.start,
      title: event.title,
      url: event.url,
    })

    case Repo.insert(changeset) do
      {:ok, event} ->
        {:ok, event}
      {:error, changeset} ->
        IO.inspect(changeset)
        {:error, "Error inserting event into db"}
    end
  end
end
