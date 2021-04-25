defmodule Floofcatcher.Discord.Command.TeamInfo do
  @behaviour Nosedrum.Command
  @behaviour Floofcatcher.Discord.Command

  import Nostrum.Struct.Embed
  alias Nostrum.Api
  alias Floofcatcher.{
    DiscordGuild,
    Repo,
    Team
  }

  def usage, do: ["team [team id]"]
  def description, do: "Get info about (your) CTFtime team"
  def predicates, do: []
  def parse_args(args), do: args

  def command(msg, []) do
    case get_team_embed(msg) do
      {:ok, embed} ->
        {:ok, _msg} = Api.create_message(msg.channel_id, embed: embed)
      {:error, reason} ->
        {:ok, _msg} = Api.create_message(msg.channel_id, "Something went wrong, reason: `#{reason}`")
    end
  end

  def command(msg, [team]) do
    team = Poison.encode!(Floofcatcher.Ctftime.Api.get_team(team))

    # TODO: Create embed
    {:ok, _msg} = Api.create_message(msg.channel_id, "```json\n#{team}\n```")
  end

  def register() do
    IO.puts("TODO: Initialize test command")
  end

  @spec get_team_embed(Nostrum.Struct.Message.__struct__) :: {:ok, Nostrum.Struct.Embed.__struct__} | {:error, String.t()}
  defp get_team_embed(msg) do
    case Repo.get_by(DiscordGuild, snowflake: Integer.to_string(msg.guild_id)) |> Repo.preload(:team) do
      nil ->
        {:error, "owo whats this, bot not in guild"}
      guild ->
        get_team_embed(msg, guild.team.remote_id)
    end
  end

  @spec get_team_embed(Nostrum.Struct.Message.__struct__, Team.__struct__) :: {:ok, Nostrum.Struct.Embed.__struct__} | {:error, String.t()}
  defp get_team_embed(_msg, team_id) do
    case Floofcatcher.Ctftime.Api.get_team(Integer.to_string(team_id)) do
      {:ok, team} ->
        embed =
          %Nostrum.Struct.Embed{}
          |> put_title(team.name)
          |> put_description(team.description)
          |> put_color(52479)
          |> put_url(team.url)
          |> put_field("Rating", Integer.to_string(team.rating), true)
          |> put_field("Country", team.country, true)

        {:ok, embed}
      _ ->
        {:error, "couldnt find team"}
    end
  end
end
