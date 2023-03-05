defmodule Streamaze.Finances.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :amount, :float
    field :currency, :string
    field :amount_in_usd, :float

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :currency, :amount_in_usd, :streamer_id])
    |> validate_required([:amount, :currency, :amount_in_usd, :streamer_id])
    |> foreign_key_constraint(:streamer_id)
  end
end
