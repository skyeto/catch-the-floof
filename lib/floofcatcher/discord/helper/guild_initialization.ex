defmodule Floofcatcher.Discord.Helper.GuildInitialization do
  @moduledoc """
  Helpers to initialize either a new guild or to check
  if a guild has already been initialized.
  """
  require Logger
  alias Floofcatcher.Repo
  alias Floofcatcher.DiscordGuild
  import Nostrum.Struct.Embed
  use Exceptional.Value
  use Exceptional.TaggedStatus, only: :operators

  @verification_title "⚠ CTFtime team verification ⚠"
  @verification_color 16734464
  @verification_descr """
  Before you can use the hosted version of *Floofcatcher* you must \
  verify your team on CTFtime. Since we don't yet have access to \
  the OAuth2 provider the verification is a bit more involved but \
  still super quick!

  **How?**
  >> Send `/verify start [team id]` in this channel
  >> Add the code returned by the command to your team description
  >> Send `/verify check` in this channel.
  """

  def initialize(guild_id) do
    guild_get_or_create(guild_id)
    ~> create_roles()
    ~> create_category()
    ~> create_text_channels()
    ~> create_voice_channels()
    |> set_initialized()
  end

  defp guild_get_or_create(guild_id) do
    case Repo.get_by(DiscordGuild, snowflake: Integer.to_string(guild_id)) do
      nil ->
        create_new_guild(%{id: guild_id})
      guild_db = %DiscordGuild{} ->
        %{id: guild_id, db: guild_db}
    end
  end

  defp create_new_guild(guild) do
    case Repo.insert(%DiscordGuild{snowflake: Integer.to_string(guild.id), verified: false}) do
      {:ok, guild_db} ->
        Map.put(guild, :db, guild_db)
      {:error, _changeset} ->
        %RuntimeError{message: "Failed to insert guild into database"}
    end
  end

  defp create_category(guild) do
    case Nostrum.Api.get_guild_channels(guild.id) do
      {:ok, channels} ->
        case Enum.find(channels, fn channel -> String.equivalent?(channel.name, "floofcatcher") and channel.type == 4 end) do
          nil ->
            {:ok, category} = Nostrum.Api.create_guild_channel(guild.id, name: "floofcatcher", type: 4)

            Map.put(guild, :category, category)
          category ->
            Map.put(guild, :category, category)
        end
      {:error, error} ->
        error
    end
  end

  defp create_text_channels(guild) do
    case Nostrum.Api.get_guild_channels(guild.id) do
      {:ok, channels} ->
        case Enum.find(channels, fn channel -> String.equivalent?(channel.name, "status") and channel.type == 0 end) do
          nil ->
            {:ok, channel} = Nostrum.Api.create_guild_channel(guild.id, name: "status", parent_id: guild.category.id)

            guild
            |> Map.put(:channel, channel)
            |> send_introduction()
          channel ->
            Map.put(guild, :channel, channel)
        end
      {:error, error} ->
        error
    end
  end

  defp create_voice_channels(guild) do
    case Nostrum.Api.get_guild_channels(guild.id) do
      {:ok, channels} ->
        case Enum.find(channels, fn channel -> String.equivalent?(channel.name, "Create new room") and channel.type == 2 end) do
          nil ->
            {:ok, channel} = Nostrum.Api.create_guild_channel(guild.id, name: "Create new room", type: 2, parent_id: guild.category.id)

            Map.put(guild, :voice, channel)
          channel ->
            Map.put(guild, :voice, channel)
        end
    end
  end

  defp create_roles(guild) do
    guild
  end

  defp send_introduction(guild) do
    if guild.db.verified == false do
      embed =
        %Nostrum.Struct.Embed{}
        |> put_title(@verification_title)
        |> put_description(@verification_descr)
        |> put_color(@verification_color)
      Nostrum.Api.create_message!(guild.channel.id, embed: embed)
    end

    guild
  end

  defp set_initialized(guild) do
    case ~~~guild do
      {:ok, _} ->
        changeset = DiscordGuild.changeset(guild.db, %{
          category: guild.category.id,
          bot_commands: guild.channel.id, #TODO: Change!
          voice_creator: guild.voice.id
        })
        Repo.update!(changeset)

        Logger.info("Successfully initialized guild #{guild.id}")
      {:error, reason} ->
        # TODO: Better error handling
        Logger.warning("Failed to initialize guild #{reason}")
    end
  end
end
