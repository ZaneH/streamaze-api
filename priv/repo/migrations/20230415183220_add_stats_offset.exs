# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddStatsOffset do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :stats_offset, :map
    end
  end
end
