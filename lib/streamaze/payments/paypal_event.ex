# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Payments.PaypalEvent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paypal_events" do
    field :event_type, :string
    field :event_id, :string
    field :raw_body, :string

    belongs_to :user, Streamaze.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(paypal_event, attrs) do
    paypal_event
    |> cast(attrs, [:event_type, :event_id, :raw_body, :user_id])
    |> validate_required([:event_type, :event_id, :raw_body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
