defmodule Streamaze.Repo.Migrations.AddStreamStartTime do
  use Ecto.Migration

  def change do
    alter table(:live_streams) do
      add :start_time, :utc_datetime
    end
  end
end
