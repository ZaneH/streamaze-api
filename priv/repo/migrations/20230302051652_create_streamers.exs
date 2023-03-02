defmodule Streamaze.Repo.Migrations.CreateStreamers do
  use Ecto.Migration

  def change do
    create table(:streamers) do
      add :name, :string
      add :youtube_url, :string

      timestamps()
    end
  end
end
