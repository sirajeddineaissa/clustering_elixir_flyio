defmodule TestElixirFlyio.Repo do
  use Ecto.Repo,
    otp_app: :test_elixir_flyio,
    adapter: Ecto.Adapters.Postgres
end
