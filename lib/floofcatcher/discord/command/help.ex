defmodule Floofcatcher.Discord.Command.Help do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed

  def usage, do: ["help"]
  def description, do: "Overview of supported commands"
  def predicates, do: []
  def parse_args(args), do: Enum.join(args, " ")

  def command(msg, _) do
    response = "Help goes here"
    {:ok, _msg} = Nostrum.Api.create_message(msg.channel_id, response)
  end

  def register() do

  end
end
