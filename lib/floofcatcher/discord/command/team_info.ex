defmodule Floofcatcher.Discord.Command.TeamInfo do
  @behaviour Nosedrum.Command
  @behaviour Floofcatcher.Discord.Command

  alias Nostrum.Api

  def usage, do: ["team [team id]"]
  def description, do: "Get info about CTFtime team"
  def predicates, do: []
  def parse_args(args), do: args

  def command(msg, []) do
    {:ok, _msg} = Api.create_message(msg.channel_id, "Usage `/team [id]`")
  end

  def command(msg, [team]) do
    team = Poison.encode!(Floofcatcher.Ctftime.Api.get_team(team))

    # TODO: Create embed
    {:ok, _msg} = Api.create_message(msg.channel_id, "```json\n#{team}\n```")
  end

  def register() do
    IO.puts("TODO: Initialize test command")
  end
end
