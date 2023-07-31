defmodule Streamaze.Accounts.Streamer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "streamers" do
    field :name, :string
    field :youtube_url, :string

    field :chat_config, :map
    field :clip_config, :map
    field :obs_config, :map, redact: true
    field :viewers_config, :map
    field :donations_config, :map, redact: true
    field :lanyard_config, :map, redact: true
    field :stats_offset, :map

    belongs_to :user, Streamaze.Accounts.User

    has_many :live_streams, Streamaze.Streams.LiveStream
    has_many :expenses, Streamaze.Finances.Expense
    has_many :donations, Streamaze.Finances.Donation
    has_many :giveaway_entries, Streamaze.Giveaways.GiveawayEntry

    has_many :streamer_managers, Streamaze.StreamerManager
    has_many :users, through: [:streamer_managers, :user]

    timestamps()
  end

  @doc false
  def changeset(streamer, attrs) do
    streamer
    |> cast(attrs, [
      :name,
      :youtube_url,
      :chat_config,
      :clip_config,
      :obs_config,
      :viewers_config,
      :donations_config,
      :lanyard_config,
      :user_id
    ])
    |> cast_assoc(:streamer_managers, required: false)
    |> unique_constraint(:youtube_url)
  end
end
