# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Streams.LiveStream do
  use Ecto.Schema
  import Ecto.Changeset

  schema "live_streams" do
    field :is_subathon, :boolean, default: false
    field :subathon_start_time, :utc_datetime
    field :subathon_minutes_per_dollar, :float
    field :subathon_seconds_added, :float
    field :subathon_start_minutes, :float
    field :start_time, :utc_datetime
    field :donation_goal, :float
    field :donation_goal_currency, :string
    field :is_live, :boolean, default: false
    field :subathon_ended_time, :utc_datetime

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(live_stream, attrs) do
    live_stream
    |> cast(attrs, [
      :is_subathon,
      :subathon_start_time,
      :subathon_start_minutes,
      :subathon_minutes_per_dollar,
      :subathon_seconds_added,
      :start_time,
      :donation_goal,
      :donation_goal_currency,
      :is_live,
      :streamer_id,
      :subathon_ended_time
    ])
    |> validate_required([:streamer_id])
    |> foreign_key_constraint(:streamer_id)
    |> unique_constraint(:streamer_id)
  end
end
