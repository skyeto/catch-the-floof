defmodule Floofcatcher.Repo do
  use Ecto.Repo,
    otp_app: :floofcatcher,
    adapter: Ecto.Adapters.Postgres
end
