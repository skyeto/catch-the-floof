defmodule Floofcatcher.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :remote_id, :integer
    field :name, :string
    field :description, :string
    field :logo, :string
    field :country, :string
    field :academic, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:remote_id, :name, :description, :country, :academic, :logo])
    |> validate_required([:remote_id, :name])
  end
end
