# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddHasTrialedToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :has_trialed, :boolean, default: false
    end
  end
end
