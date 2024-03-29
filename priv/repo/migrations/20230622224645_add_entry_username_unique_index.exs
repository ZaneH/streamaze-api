# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddEntryUsernameUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:giveaway_entries, [:entry_username])
  end
end
