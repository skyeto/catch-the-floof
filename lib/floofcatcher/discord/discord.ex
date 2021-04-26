defmodule Floofcatcher.Discord do
  @moduledoc """
  Discord service, handles incoming events
  """
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api
  alias Floofcatcher.Discord.Command
  alias Floofcatcher.Discord.Handler.{
    MessageCreate,
    Ready,
    VoiceStateUpdate
  }

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    Command.Registrator.register_all()
    Ready.handle()
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    MessageCreate.handle(msg)
    Logger.debug("Received message: " <> msg.content)
  end

  def handle_event({:VOICE_STATE_UPDATE, state, _ws_state}) do
    VoiceStateUpdate.handle(state)
  end

  def handle_event({:INTERACTION_CREATE, payload, _ws_state}) do
    Logger.debug("Received command: " <> payload.data.name)
  end

  def handle_event(_event) do
    :noop
  end
end
