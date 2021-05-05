defmodule Floofcatcher.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_id, :integer
      add :ctf_id, :integer
      add :title, :string
      add :url, :string
      add :restrictions, :string
      add :format, :string
      add :ctftime_url, :string
      add :onsite, :boolean, default: false, null: false
      add :location, :string
      add :start, :naive_datetime
      add :duration, :integer
      add :weight, :float

      timestamps()
    end

  end
end
