# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateStripeCustomers do
  use Ecto.Migration

  def change do
    create table(:stripe_customers) do
      add :user_id, references(:users, on_delete: :nothing)

      add :stripe_id, :string
      add :email, :string
      add :name, :string
      add :plan, :string

      timestamps()
    end
  end
end
