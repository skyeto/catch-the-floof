defmodule Floofcatcher.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :ctf_id, :integer
    field :ctftime_url, :string
    field :duration, :integer
    field :event_id, :integer
    field :format, :string
    field :location, :string
    field :onsite, :boolean, default: false
    field :restrictions, :string
    field :start, :naive_datetime
    field :title, :string
    field :url, :string
    field :weight, :float

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event_id, :ctf_id, :title, :url, :restrictions, :format, :ctftime_url, :onsite, :location, :start, :duration, :weight])
    |> validate_required([:event_id, :ctf_id, :title, :url, :restrictions, :format, :ctftime_url, :onsite, :location, :start, :duration])
  end
end
