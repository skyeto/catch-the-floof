defmodule Floofcatcher.Repo.Migrations.DiscordGuildVerificationBelongsToDiscordGuild do
  use Ecto.Migration

  def change do
    alter table(:discord_guild_verifications) do
      add :discord_guild_id, references(:discord_guilds)
    end
  end
end
