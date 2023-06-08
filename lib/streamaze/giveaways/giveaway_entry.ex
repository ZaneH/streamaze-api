defmodule Streamaze.Giveaways.GiveawayEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "giveaway_entries" do
    field :entry_username, :string
    field :win_count, :integer, default: 0
    field :last_win, :utc_datetime
    field :streamer_id, :integer
    field :chat_username, :string
  end

  @doc false
  def changeset(giveaway_entry, attrs) do
    giveaway_entry
    |> cast(attrs, [:entry_username, :win_count, :last_win, :chat_username])
    |> validate_number(:win_count, greater_than_or_equal_to: 0)
  end
end
