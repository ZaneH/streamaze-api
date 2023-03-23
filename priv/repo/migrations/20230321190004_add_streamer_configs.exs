defmodule Streamaze.Repo.Migrations.AddStreamerConfigs do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :chat_config, :map
      add :clip_config, :map
      add :obs_config, :map
      add :viewers_config, :map
      add :donations_config, :map
      add :lanyard_config, :map
    end
  end
end
