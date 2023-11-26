# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo do
  use Ecto.Repo,
    otp_app: :streamaze,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
