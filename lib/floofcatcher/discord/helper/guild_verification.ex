defmodule Floofcatcher.Discord.Helper.GuildVerification do
  @doc """
  Returns verification code
  """
  alias Floofcatcher.{
    Repo,
    DiscordGuild,
    DiscordGuildVerification,
    Team,
    Ctftime
  }

  def begin_verification(guild_id, team_id) do
    with  {:ok, team} <- get_or_create_team(team_id),
          {:ok, guild} <- get_guild(guild_id),
          :ok <- check_team_guild(guild, team),
          {:ok, code} <- get_or_create_verification_code(guild)
    do
      {:ok, team, code}
    else
      err ->
        IO.puts("Something went wrong during guild / team verification")
        IO.inspect(err)
        {:error, "failed verification"}
        # TODO: Error checking
    end
  end

  @spec check_verification(integer) :: {:ok, %Team{}} | {:error, String.t()}
  def check_verification(guild_id) do
    with  {:ok, guild} <- get_guild(guild_id),
          {:ok, team} <- update_team_description(guild.team),
          {:ok, _} <- check_verification(guild, team),
          {:ok, _} <- set_verification(guild)
    do
      {:ok, "verification checks out"}
    else
      reason ->
        IO.inspect(reason)
        {:error, "verification failed"}
    end
  end

  defp get_or_create_verification_code(guild) do
    case Repo.get_by(DiscordGuildVerification, discord_guild_id: guild.id) do
      %DiscordGuildVerification{code: code} ->
        {:ok, code}
      nil ->
        create_verification_code(guild)
    end
  end

  defp create_verification_code(guild) do
    code = Ecto.UUID.generate()

    case Repo.insert(%DiscordGuildVerification{discord_guild_id: guild.id, code: code}) do
      {:ok, _} ->
        {:ok, code}
      _ ->
        {:error, "Something went wrong creating verification code"}
    end
  end

  @spec get_guild(integer) :: {:ok, DiscordGuild.__struct__} | {:error, String.t()}
  defp get_guild(guild_id) do
    case Repo.get_by(DiscordGuild, snowflake: Integer.to_string(guild_id)) |> Repo.preload(:team) do
      guild = %DiscordGuild{} ->
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
        case is_nil(guild.team_id) do
          true ->
            DiscordGuild.changeset(guild, %{})
            |> Ecto.Changeset.put_assoc(:team, team)
            |> Repo.update!()
            :ok
          false ->
            {:error, "Channel already belongs to another team, you aren't cheating right?"}
        end
    end
  end

  defp get_or_create_team(team_id) do
    case Repo.get_by(Team, remote_id: team_id) do
      team = %Team{} ->
        {:ok, team}
      nil ->
        create_team(team_id)
    end
  end

  # TODO: Errors
  @spec update_team_description(Team.__struct__) :: {:ok, Team.__struct__} #| {:error, String.t()}
  defp update_team_description(team) do
    {:ok, updated} = Ctftime.Api.get_team(Integer.to_string(team.remote_id))
    {:ok, team} = Team.changeset(team, %{description: updated.description}) |> Repo.update()

    {:ok, team}
  end

  @spec check_verification(DiscordGuild.__struct__, Team.__struct__) :: {:ok, String.t()} | {:error, String.t()}
  defp check_verification(guild, team) do
    if guild.team_id != team.id do
      {:error, "guild doesn't belong to team"}
    end

    guild = Repo.preload(guild, :discord_guild_verification)
    case is_nil(guild.discord_guild_verification) do
      false ->
        if String.contains?(team.description, "Floofcatcher: " <> guild.discord_guild_verification.code) do
          {:ok, "verified"}
        else
          {:error, "code mismatch"}
        end
      true ->
        {:error, "verification process not started"}
    end
  end

  @spec set_verification(DiscordGuild.__struct__) :: {:ok, DiscordGuild.__struct__} | {:error, DiscordGuild.__changeset__}
  defp set_verification(guild) do
    DiscordGuild.changeset(guild, %{verified: true})
    |> Repo.update()
  end

  defp create_team(team_id) do
    with  {:ok, team} <- Ctftime.Api.get_team(team_id),
          {:ok, team_db} <- Repo.insert(%Team{
            remote_id: team.id,
            name: team.name,
            description: team.description,
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
