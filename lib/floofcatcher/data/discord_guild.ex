defmodule Floofcatcher.DiscordGuild do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discord_guilds" do
    field :snowflake, :string
    field :verified, :boolean, default: false

    belongs_to :team, Floofcatcher.Team
    has_one :discord_guild_verification, Floofcatcher.DiscordGuildVerification

    timestamps()
  end

  @doc false
  def changeset(discord_guild, attrs) do
    discord_guild
    |> cast(attrs, [:snowflake, :verified])
    |> validate_required([:snowflake, :verified])
  end
end
