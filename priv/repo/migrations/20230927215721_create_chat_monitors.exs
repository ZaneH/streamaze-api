defmodule Streamaze.Repo.Migrations.CreateChatMonitors do
  use Ecto.Migration

  def change do
    create table(:chat_monitors) do
      add :streamer_id, references(:streamers, on_delete: :nothing), null: false
      add :live_stream_id, references(:live_streams, on_delete: :nothing), null: false

      add :monitor_start, :utc_datetime, null: false
      add :monitor_end, :utc_datetime

      add :chat_activity, :map, null: false, default: %{}

      timestamps()
    end
  end
end
