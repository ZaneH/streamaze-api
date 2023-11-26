# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateGiveawayEntries do
  use Ecto.Migration

  def change do
    create table(:giveaway_entries) do
      add :entry_username, :string
      add :streamer_id, references(:streamers, on_delete: :delete_all)
      add :win_count, :integer, default: 0
      add :last_win, :utc_datetime

      timestamps()
    end
  end
end
