defmodule Streamaze.Finances.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :value, Money.Ecto.Composite.Type
    field :amount_in_usd, :decimal

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:value, :amount_in_usd, :streamer_id])
    |> validate_required([:value, :amount_in_usd, :streamer_id])
    |> foreign_key_constraint(:streamer_id)
  end
end
