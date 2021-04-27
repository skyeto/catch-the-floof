defmodule Floofcatcher.Discord.Command.JoinEvent do
  @behaviour Nosedrum.Command
  @behaviour Floofcatcher.Discord.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed

  def usage, do: ["join [event]"]
  def description, do: "Join an event"
  def predicates, do: [] # TODO: Check verification!!
  def parse_args(args), do: Enum.join(args, " ")

  def command(msg, "") do
    response = "Event ID is required"
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  @spec command(Nostrum.Struct.Message.__struct__, String.t) :: any
  def command(msg, event_id) do
    response = "Joining event #{event_id}"
    # TODO: Create permissions
    # TODO: Get event from CTFtime
    # TODO: Send initial message
    # TODO: Add event to database
    {:ok, event} = Floofcatcher.Discord.Helper.Event.get_or_create_event(String.to_integer(event_id))

    {:ok, channel_category} = Nostrum.Api.create_guild_channel(msg.guild_id, name: "event-#{event.title}", type: 4)
    {:ok, channel} = Nostrum.Api.create_guild_channel(msg.guild_id, name: "general", parent_id: channel_category.id)

    message =
      %Nostrum.Struct.Embed{}
      |> put_title("Event Info")
      |> put_description("❌ Rev - A cool chall\n✔ Rev - Random chall")
      |> put_url("https://ctftime.org/event/1265")
    {:ok, _msg} = Nostrum.Api.create_message(channel.id, embed: message)
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  def register() do
    :ok
  end
end
