defmodule Streamaze.Giveaways.GiveawayEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "giveaway_entries" do
    field :entry_username, :string
    field :win_count, :integer, default: 0
    field :last_win, :utc_datetime
    field :chat_username, :string

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(giveaway_entry, attrs \\ %{}) do
    giveaway_entry
    |> cast(attrs, [:entry_username, :win_count, :last_win, :chat_username, :streamer_id])
    |> validate_number(:win_count, greater_than_or_equal_to: 0)
    |> validate_required([:entry_username, :streamer_id])
    |> foreign_key_constraint(:streamer_id)
    |> unique_constraint(:id, name: :giveaway_entries_pkey)
    |> unique_constraint(:chat_username)
    |> unique_constraint(:entry_username)
  end
end
