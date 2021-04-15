defmodule Floofcatcher.Discord.Command.TestCommand do
  @behaviour Nosedrum.Command

  alias Nostrum.Api

  def usage, do: ["test"]
  def description, do: "Test command in bot"
  def predicates, do: []

  def command(msg, []) do
    IO.inspect(Floofcatcher.Ctftime.Api.get_team("26569"))
    {:ok, _msg} = Api.create_message(msg.channel_id, "Hello from Floofcatcher ;)")
  end

  def register() do
    IO.puts("TODO: Initialize test command")
  end
end
