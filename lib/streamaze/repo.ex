defmodule Streamaze.Repo do
  use Ecto.Repo,
    otp_app: :streamaze,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
