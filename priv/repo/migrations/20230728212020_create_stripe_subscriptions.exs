# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateStripeSubscriptions do
  use Ecto.Migration

  # Stripe subscription object: https://stripe.com/docs/api/subscriptions/object
  def change do
    create table(:stripe_subscriptions) do
      add :stripe_id, :string
      add :current_period_end, :integer
      add :status, :string
      add :trial_end, :integer

      add :customer_id, references(:stripe_customers, on_delete: :nothing)

      timestamps()
    end
  end
end
