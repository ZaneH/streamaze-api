defmodule Streamaze.Streams.LiveStream do
  use Ecto.Schema
  import Ecto.Changeset

  schema "live_streams" do
    field :donation_goal, :float
    field :donation_goal_currency, :string
    field :is_live, :boolean, default: false
    field :is_subathon, :boolean, default: false
    field :subathon_minutes_per_dollar, :float
    field :subathon_seconds_added, :float
    field :subathon_start_minutes, :float

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(live_stream, attrs) do
    live_stream
    |> cast(attrs, [
      :is_subathon,
      :subathon_start_minutes,
      :subathon_minutes_per_dollar,
      :subathon_seconds_added,
      :donation_goal,
      :donation_goal_currency,
      :is_live,
      :streamer_id
    ])
    |> validate_required([:streamer_id])
    |> foreign_key_constraint(:streamer_id)
  end
end
