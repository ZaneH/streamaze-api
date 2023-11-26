# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers) do
      add :name, :string
      add :youtube_url, :string

      timestamps()
    end

    create unique_index(:streamers, [:youtube_url])
  end
end
