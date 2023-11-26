# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddMonthsToDonation do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :months, :integer
    end
  end
end
