defmodule Floofcatcher.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :remote_id, :integer
      add :name, :string
      add :description, :string
      add :country, :string
      add :academic, :boolean, default: false, null: false
      add :logo, :string

      timestamps()
    end

  end
end
