defmodule Streamaze.Finances.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :amount, :float
    field :currency, :string
    field :streamer_id, :id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :currency, :streamer_id])
    |> validate_required([:amount, :currency, :streamer_id])
    |> foreign_key_constraint(:streamer_id)
  end
end
