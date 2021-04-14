defmodule Floofcatcher.Repo.Migrations.CreateDiscordGuildVerifications do
  use Ecto.Migration

  def change do
    create table(:discord_guild_verifications) do
      add :code, :string
      add :used, :boolean, default: false, null: false

      timestamps()
    end

  end
end
