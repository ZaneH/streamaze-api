defmodule Streamaze.Payments.StripeCustomer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stripe_customers" do
    field :stripe_id, :string
    field :email, :string
    field :name, :string
    field :plan, :string

    belongs_to :user, Streamaze.Accounts.User

    has_many :stripe_subscriptions, Streamaze.Payments.StripeSubscription,
      foreign_key: :customer_id

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:stripe_id, :user_id, :email, :name, :plan])
    |> validate_required([:stripe_id, :email, :name])
    |> unique_constraint(:stripe_id)
    |> foreign_key_constraint(:user_id)
  end
end
