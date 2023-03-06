defmodule Streamaze.Finances.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :value, Money.Ecto.Composite.Type
    field :amount_in_usd, :float
    field :message, :string
    field :metadata, :map
    field :sender, :string
    field :type, :string

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:value, :amount_in_usd, :sender, :type, :streamer_id, :message, :metadata])
    |> validate_required([:value, :amount_in_usd, :sender, :type, :streamer_id])
    |> validate_number(:amount_in_usd, greater_than: 0)
    |> foreign_key_constraint(:streamer_id)
  end
end
