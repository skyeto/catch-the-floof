defmodule Floofcatcher.Discord do
  use Nostrum.Consumer
  require Logger
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.debug("Received message: " <> msg.content)

    case msg.content do
      ".list_ctf" ->
        Logger.warn("CTF Listing not implemented")
      ".kill" ->
        raise "bot process was killed :("
      _ ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
