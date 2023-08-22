defmodule NotKnitting.Repo do
  use Ecto.Repo,
    otp_app: :not_knitting,
    adapter: Ecto.Adapters.Postgres
end
