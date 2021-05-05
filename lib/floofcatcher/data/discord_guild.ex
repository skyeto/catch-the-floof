defmodule Floofcatcher.DiscordGuild do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discord_guilds" do
    field :snowflake, :string
    field :verified, :boolean, default: false

    field :category, :integer
    field :bot_commands, :integer
    field :voice_creator, :integer

    belongs_to :team, Floofcatcher.Team
    has_one :discord_guild_verification, Floofcatcher.DiscordGuildVerification

    timestamps()
  end

  @doc false
  def changeset(discord_guild, attrs) do
    discord_guild
    |> cast(attrs, [:snowflake, :verified, :category, :bot_commands, :voice_creator])
    |> validate_required([:snowflake, :verified])
  end
end
