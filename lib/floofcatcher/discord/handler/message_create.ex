defmodule Floofcatcher.Discord.Handler.MessageCreate do
  require Logger

  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nostrum.Api

  def handle(msg) do
    Logger.debug("Handling message...")
    case CommandInvoker.handle_message(msg, Nosedrum.Storage.ETS) do
      {:error, {:unknown_command, _name, :known, known}} ->
        Api.create_message(msg.channel_id, "Unknown command :(")
      {:error, :predicate, {:error, reason}} ->
        Api.create_message(msg.channel_id, "Error: #{reason}")
      :ignored ->
        :ok
      _ ->
        Api.delete_message(msg)
    end
  end
end
