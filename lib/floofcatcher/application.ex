defmodule Floofcatcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Floofcatcher.Repo,
      # Start the Telemetry supervisor
      FloofcatcherWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Floofcatcher.PubSub},
      # Start the Endpoint (http/https)
      FloofcatcherWeb.Endpoint,
      Nosedrum.Storage.ETS,
      Floofcatcher.Discord
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Floofcatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FloofcatcherWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
