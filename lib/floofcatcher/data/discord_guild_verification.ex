defmodule Floofcatcher.DiscordGuildVerification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discord_guild_verifications" do
    field :code, :string
    field :used, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(discord_guild_verification, attrs) do
    discord_guild_verification
    |> cast(attrs, [:code, :used])
    |> validate_required([:code, :used])
  end
end
