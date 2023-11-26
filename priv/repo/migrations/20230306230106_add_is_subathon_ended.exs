# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddIsSubathonEnded do
  use Ecto.Migration

  def change do
    alter table(:live_streams) do
      add :subathon_ended_time, :utc_datetime
    end
  end
end
