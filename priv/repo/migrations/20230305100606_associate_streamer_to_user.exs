# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AssociateStreamerToUser do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    alter table(:users) do
      add :streamer_id, references(:streamers, on_delete: :delete_all)
    end
  end
end
