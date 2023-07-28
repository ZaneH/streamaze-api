defmodule Streamaze.Payments do
  alias Streamaze.Repo
  alias Streamaze.Payments.StripeCustomer
  alias Streamaze.Payments.StripeSubscription

  def get_customer_by_stripe_id(stripe_id) do
    Repo.get_by(StripeCustomer, stripe_id: stripe_id)
  end

  def create_customer(%{
        email: email,
        name: name,
        stripe_id: stripe_id,
        user_id: user_id,
        plan: plan
      }) do
    %StripeCustomer{}
    |> StripeCustomer.changeset(%{
      stripe_id: stripe_id,
      email: email,
      name: name,
      user_id: user_id,
      plan: plan
    })
    |> Repo.insert()
  end

  def create_subscription(%{
        stripe_id: stripe_id,
        customer_id: customer_id,
        current_period_end: current_period_end,
        status: status,
        trial_end: trial_end
      }) do
    %StripeSubscription{}
    |> StripeSubscription.changeset(%{
      stripe_id: stripe_id,
      customer_id: customer_id,
      current_period_end: current_period_end,
      status: status,
      trial_end: trial_end
    })
    |> Repo.insert()
  end

  def update_subscription(%{
        customer_id: customer_id,
        status: status,
        current_period_end: current_period_end
      }) do
    subscription = Repo.get_by(StripeSubscription, customer_id: customer_id)

    subscription
    |> StripeSubscription.changeset(%{
      status: status,
      current_period_end: current_period_end
    })
    |> Repo.update()
  end
end
