# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateLiveStreams do
  use Ecto.Migration

  def change do
    create table(:live_streams) do
      add :is_subathon, :boolean, default: false, null: false
      add :subathon_start_time, :utc_datetime
      add :subathon_start_minutes, :float
      add :subathon_minutes_per_dollar, :float
      add :subathon_seconds_added, :float
      add :donation_goal, :float
      add :donation_goal_currency, :string
      add :is_live, :boolean, default: false, null: false
      add :streamer_id, references(:streamers, on_delete: :nothing)

      timestamps()
    end

    create index(:live_streams, [:streamer_id])
  end
end
