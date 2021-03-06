defmodule Floofcatcher.Discord.Command.Registrator do
  alias Nosedrum.Storage.ETS, as: CommandStorage
  require Logger

  alias Floofcatcher.Discord.Command
  @commands %{
    "test" => Command.TestCommand,
    "join" => Command.JoinEvent,
    "verify" => Command.VerifyTeam,
    "team" => Command.TeamInfo,
    "help" => Command.Help
  }

  @spec register_all :: :ok
  def register_all() do
    Enum.each(@commands, &register_command/1)
  end

  @spec register_command({String.t(), Floofcatcher.Discord.Command}) :: :ok
  defp register_command({name, module}) do
    Logger.debug("Registering command: " <> name)
    module.register()
    CommandStorage.add_command([name], module)
  end
end
