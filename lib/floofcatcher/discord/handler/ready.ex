defmodule Floofcatcher.Discord.Handler.Ready do
  require Logger

  alias Nostrum.Api

  def handle() do
    Logger.info("Initializing bot...")
    Enum.map(Api.get_current_user_guilds!(), fn guild -> initialize_guild(guild) end)
    Logger.info("Bot initialized")
  end

  defp initialize_guild(guild) do
    guild
    |> initialize_channels()
    |> check_verification()
  end

  defp initialize_channels(guild) do
    bot_channel = Api.get_guild_channels!(guild.id)
                  |> Enum.find(fn channel -> String.equivalent?(channel.name, "Floofcatcher") end)

    IO.inspect(bot_channel)

    guild
  end

  defp check_verification(guild) do
    guild
  end
end
