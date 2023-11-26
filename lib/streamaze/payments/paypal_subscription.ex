# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.PaypalSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paypal_subscriptions" do
    field :subscription_id, :string
    field :item_id, :string

    belongs_to :user, Streamaze.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(paypal_subscription, attrs) do
    paypal_subscription
    |> cast(attrs, [:subscription_id, :user_id, :item_id])
    |> validate_required([:subscription_id, :user_id, :item_id])
    |> foreign_key_constraint(:user_id)
  end
end
