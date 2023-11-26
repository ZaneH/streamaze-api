# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Streams.ChatMonitor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_monitors" do
    belongs_to :streamer, Streamaze.Accounts.Streamer
    belongs_to :live_stream, Streamaze.Streams.LiveStream

    field :monitor_start, :utc_datetime
    field :monitor_end, :utc_datetime

    field :chat_activity, :map

    timestamps()
  end

  @doc false
  def changeset(chat_monitor, attrs) do
    chat_monitor
    |> cast(attrs, [:streamer_id, :live_stream_id, :monitor_start, :monitor_end, :chat_activity])
    |> validate_required([
      :streamer_id,
      :live_stream_id,
      :monitor_start,
      :chat_activity
    ])
  end
end
