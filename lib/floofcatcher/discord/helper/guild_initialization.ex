defmodule Floofcatcher.Discord.Helper.GuildInitialization do
  @moduledoc """
  Helpers to initialize either a new guild or to check
  if a guild has already been initialized.
  """
  require Logger
  alias Floofcatcher.Repo
  use Exceptional.Value
  use Exceptional.TaggedStatus, only: :operators

  def initialize(guild_id) do
    case Repo.get_by(Floofcatcher.DiscordGuild, id: Integer.to_string(guild_id)) do
      repo = %Floofcatcher.DiscordGuild{} -> IO.puts("Success!")
      nil ->
        %{id: guild_id}
        |> create_new_guild()
        ~> create_roles()
        ~> create_channels()
        |> set_initialized()
      _ -> IO.puts("Unexpected result")
    end
  end

  defp create_new_guild(guild) do
    case Repo.insert(%Floofcatcher.DiscordGuild{snowflake: Integer.to_string(guild.id), verified: false}) do
      {:ok, guild_db} ->
        Map.put(guild, :db, guild_db)
      {:error, _changeset} ->
        %RuntimeError{message: "Failed to insert guild into database"}
    end
  end

  defp create_channels(guild) do
    case Nostrum.Api.get_guild_channels(guild.id) do
      {:ok, channels} ->
        case Enum.find(channels, fn channel -> String.equivalent?(channel.name, "floofcatcher") end) do
          nil ->
            {:ok, channel} = Nostrum.Api.create_guild_channel(guild.id, name: "floofcatcher")

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

  defp create_roles(guild) do
    guild
  end

  defp send_introduction(guild) do
    _message = Nostrum.Api.create_message!(guild.channel.id, "init message owo")
    guild
  end

  defp set_initialized(guild) do
    case ~~~guild do
      {:ok, _} ->
        Logger.info("Successfully initialized guild #{guild.id}")
      {:error, reason} ->
        # TODO: Better error handling
        Logger.warning("Failed to initialize guild #{reason}")
    end
  end
end
