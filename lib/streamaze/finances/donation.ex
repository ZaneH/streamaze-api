# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Finances.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :value, Money.Ecto.Composite.Type
    field :amount_in_usd, :decimal
    field :message, :string
    field :metadata, :map
    field :sender, :string
    field :type, :string
    field :months, :integer
    field :exclude_from_profit, :boolean, default: false

    belongs_to :streamer, Streamaze.Accounts.Streamer

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [
      :value,
      :amount_in_usd,
      :sender,
      :type,
      :streamer_id,
      :message,
      :metadata,
      :months,
      :exclude_from_profit
    ])
    |> validate_required([:value, :amount_in_usd, :type, :streamer_id])
    |> foreign_key_constraint(:streamer_id)
  end
end
