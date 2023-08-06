defmodule Streamaze.Repo.Migrations.AddAdminConfigToStreamer do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :admin_config, :map
    end
  end
end
