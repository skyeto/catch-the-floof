# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nostrum,
  token: ""

config :nosedrum,
  prefix: "/"

config :floofcatcher,
  ecto_repos: [Floofcatcher.Repo]

# Configures the endpoint
config :floofcatcher, FloofcatcherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q/aDmM4rtaenjYYUFsU306lEmux7GPGYMxDt6v2G5rNn7ze5gHAyR5lONf8UWww/",
  render_errors: [view: FloofcatcherWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Floofcatcher.PubSub,
  live_view: [signing_salt: "g/V/AtrI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
