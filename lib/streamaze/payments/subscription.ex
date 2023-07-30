defmodule Streamaze.Payments.StripeSubscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stripe_subscriptions" do
    field :stripe_id, :string
    field :current_period_end, :integer
    field :status, :string
    field :trial_end, :integer

    belongs_to :stripe_customer, Streamaze.Payments.StripeCustomer, foreign_key: :customer_id

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:stripe_id, :customer_id, :current_period_end, :status, :trial_end])
    |> validate_required([:stripe_id, :current_period_end, :status])
    |> unique_constraint(:stripe_id)
    |> foreign_key_constraint(:stripe_customer_id)
  end
end
