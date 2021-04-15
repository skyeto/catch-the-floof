defmodule Floofcatcher.Discord.Command.VerifyTeam do
  @moduledoc """
  Command to verify ownership of CTFtime team. Necessary
  for multi-server with support for multi-channel
  deployment of the bot where we want to control access
  to team-specific information.

  Flow:
  >> /verify start
  << Add the following to the team description "Floofcatcher: [code]"
  >> /verify check
  << Team verified || Could not find code in team description

  TODO: start
  TODO: check
  TODO: config to enable/disable
  TODO: use oauth

  NOTE:
  It's not ideal to verify teams using this method. It
  would be better to use the CTFtime OAuth provider,
  though it requires registration.
  >> Maybe in the future. :3
  """
  @behaviour Nosedrum.Command

  alias Nostrum.Api

  def usage, do: ["verify <start|check> [team id]"]
  def description, do: "Verify that you control the CTFtime team"
  def predicates, do: []
  def parse_args(args), do: args

  def command(msg, []) do
    {:ok, _msg} = Api.create_message(msg.channel_id, "Choose an option `/verify <start|check>`")
  end

  def command(msg, ["start", team]) do
    # TODO: Start verification
    Floofcatcher.Discord.Helper.GuildVerification.begin_verification(msg.guild_id, team)
    {:ok, _msg} = Api.create_message(msg.channel_id, "Add the following to your team description on CTFtime: `Floocatcher: <code>`")
  end

  def command(msg, ["start"]) do
    {:ok, _msg} = Api.create_message(msg.channel_id, "Provide a team id from CTFtime `/verify start [team id]`")
  end

  def command(msg, ["check"]) do
    {:ok, _msg} = Api.create_message(msg.channel_id, "#TODO: Check")
  end

  def command(msg, _args) do
    {:ok, _msg} = Api.create_message(msg.channel_id, "Something went wrong.")
  end

  def register() do
    IO.puts("TODO: Initialize test command")
  end
end
