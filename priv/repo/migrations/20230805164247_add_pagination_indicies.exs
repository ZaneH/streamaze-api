# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddPaginationIndicies do
  use Ecto.Migration

  def change do
    create index(:donations, [:inserted_at])
    create index(:expenses, [:inserted_at])
  end
end
