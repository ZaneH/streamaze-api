defmodule Streamaze.Finances.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :amount, :float
    field :currency, :string
    field :message, :string
    field :metadata, :map
    field :sender, :string
    field :type, :string
    field :streamer_id, :id

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:amount, :currency, :sender, :type])
    |> validate_required([:amount, :currency, :sender, :type])
  end
end
