defmodule Streamaze.Repo.Migrations.CreateStreamerManagers do
  use Ecto.Migration

  def change do
    create table(:streamer_managers) do
      add :user_id, references(:users)
      add :streamer_id, references(:streamers)

      timestamps()
    end
  end
end
