defmodule Floofcatcher.Discord.Command.Registrator do
  alias Nosedrum.Storage.ETS, as: CommandStorage
  require Logger

  @commands %{
    "test" => Floofcatcher.Discord.Command.TestCommand
  }

  def register_all() do
    Enum.each(@commands, &register_command/1)
  end

  defp register_command({name, module}) do
    Logger.debug("Registering command: " <> name)
    module.register()
    CommandStorage.add_command([name], module)
  end
end
