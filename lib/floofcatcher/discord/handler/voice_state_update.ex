defmodule Floofcatcher.Discord.Handler.VoiceStateUpdate do
  require Logger

  alias Nostrum.Api

  def handle(state) do
    case state.channel_id == 836360310146990130 do
      true ->
        {:ok, channel} = Api.create_guild_channel(state.guild_id, name: state.member.user.username <> "'s channel", type: 2, parent_id: 836360306879627294)
        Api.modify_guild_member(state.guild_id, state.member.user.id, channel_id: channel.id)
        :ok
      false ->
        :ok
    end
  end
end
