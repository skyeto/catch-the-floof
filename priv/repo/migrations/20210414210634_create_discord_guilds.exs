defmodule Floofcatcher.Repo.Migrations.CreateDiscordGuilds do
  use Ecto.Migration

  def change do
    create table(:discord_guilds) do
      add :snowflake, :string
      add :verified, :boolean, default: false, null: false

      timestamps()
    end

  end
end
