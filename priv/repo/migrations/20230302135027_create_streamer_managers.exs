defmodule Streamaze.Repo.Migrations.CreateStreamerManagers do
  use Ecto.Migration

  def change do
    create table(:streamer_managers) do
      add :user_id, references(:users)
      add :streamer_id, references(:streamers)

      timestamps()
    end

    create unique_index(:streamer_managers, [:user_id, :streamer_id])
  end
end
