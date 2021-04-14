defmodule Floofcatcher.Repo.Migrations.DiscordGuildBelongsToTeam do
  use Ecto.Migration

  def change do
    alter table(:discord_guilds) do
      add :team_id, references(:teams)
    end
  end
end
