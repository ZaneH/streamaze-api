defmodule Streamaze.Accounts.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streamers" do
    field :name, :string
    field :youtube_url, :string
    field :streamlabs_token, :string, redact: true
    field :lanyard_api_key, :string, redact: true
    field :discord_id, :string

    has_one :user, Streamaze.Accounts.User

    has_many :live_streams, Streamaze.Streams.LiveStream
    has_many :expenses, Streamaze.Finances.Expense
    has_many :donations, Streamaze.Finances.Donation

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
