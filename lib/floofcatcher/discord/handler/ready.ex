defmodule Floofcatcher.Discord.Handler.Ready do
  require Logger

  alias Nostrum.Api
  alias Floofcatcher.Discord.Helper

  def handle() do
    Logger.info("Initializing bot...")
    Enum.map(Api.get_current_user_guilds!(), fn guild -> Helper.GuildInitialization.initialize(guild.id) end)
    Logger.info("Bot initialized")
    Api.update_status(:online, "with your flags owo")
  end
end
