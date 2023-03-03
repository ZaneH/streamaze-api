defmodule Streamaze.Accounts.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streamers" do
    field :name, :string
    field :youtube_url, :string

    has_many :live_streams, Streamaze.Streams.LiveStream

    has_many :streamer_managers, Streamaze.StreamerManager
    has_many :users, through: [:streamer_managers, :user]

    timestamps()
  end

  @doc false
  def changeset(streamer, attrs) do
    streamer
    |> cast(attrs, [:name, :youtube_url])
    |> cast_assoc(:streamer_managers, required: false)
    |> validate_required([:name, :youtube_url])
    |> unique_constraint(:youtube_url)
  end
end
