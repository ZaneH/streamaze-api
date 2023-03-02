defmodule Streamaze.Accounts.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streamers" do
    field :name, :string
    field :youtube_url, :string

    has_many :live_streams, Streamaze.Streams.LiveStream

    timestamps()
  end

  @doc false
  def changeset(streamer, attrs) do
    streamer
    |> cast(attrs, [:name, :youtube_url])
    |> validate_required([:name, :youtube_url])
    |> unique_constraint(:name)
  end
end
