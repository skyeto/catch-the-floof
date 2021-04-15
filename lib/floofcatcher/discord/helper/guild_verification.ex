defmodule Floofcatcher.Discord.Helper.GuildVerification do
  @doc """
  Returns verification code
  """
  alias Floofcatcher.Repo

  def begin_verification(guild_id, team_id) do
    with  {:ok, team} <- get_team(team_id),
          {:ok, guild} <- get_guild(guild_id),
          :ok <- check_team_guild(guild, team),
          {:ok, code} <- get_or_create_verification_code(guild)
    do
      IO.inspect(team)
      IO.inspect(code)
      team
    else
      err ->
        IO.puts("Something went wrong during guild / team verification")
        IO.inspect(err)
    end
  end

  defp get_or_create_verification_code(guild) do
    case Repo.get_by(Floofcatcher.DiscordGuildVerification, discord_guild_id: guild.id) do
      %Floofcatcher.DiscordGuildVerification{code: code} ->
        {:ok, code}
      nil ->
        create_verification_code(guild)
    end
  end

  defp create_verification_code(guild) do
    code = Ecto.UUID.generate()

    case Repo.insert(%Floofcatcher.DiscordGuildVerification{discord_guild_id: guild.id, code: code}) do
      {:ok, _} ->
        {:ok, code}
      _ ->
        {:error, "Something went wrong creating verification code"}
    end
  end

  defp get_guild(guild_id) do
    case Repo.get_by(Floofcatcher.DiscordGuild, snowflake: Integer.to_string(guild_id)) do
      guild = %Floofcatcher.DiscordGuild{} ->
        {:ok, guild}
      nil ->
        {:error, "Could not find guild"}
    end
  end

  defp check_team_guild(guild, team) do
    case guild.team_id == team.id do
      true ->
        :ok
      false ->
        case guild.team_id do
          nil ->
            :ok #TODO: Set team_id to team
          _ ->
            {:error, "Channel already belongs to another team, you aren't cheating right?"}
        end
    end
  end

  defp get_team(team_id) do
    case Repo.get_by(Floofcatcher.Team, remote_id: team_id) do
      team = %Floofcatcher.Team{} ->
        {:ok, team}
      nil ->
        create_team(team_id)
    end
  end

  defp create_team(team_id) do
    with  {:ok, team} <- Floofcatcher.Ctftime.Api.get_team(team_id),
          {:ok, team_db} <- Repo.insert(%Floofcatcher.Team{
            remote_id: team.id,
            name: team.name,
            logo: team.logo,
            country: team.country,
            academic: team.academic
          })
    do
      {:ok, team_db}
    else
      _err -> {:error, "team not found or couldn't be created"}
    end
  end
end
