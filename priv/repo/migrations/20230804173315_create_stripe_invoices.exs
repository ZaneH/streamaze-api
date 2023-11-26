# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreateStripeInvoices do
  use Ecto.Migration

  def change do
    create table(:stripe_invoices) do
      add :stripe_id, :string
      add :customer_id, references(:stripe_customers, on_delete: :nothing)
      add :amount_due, :integer
      add :amount_paid, :integer
      add :amount_remaining, :integer
      add :currency, :string
      add :date, :integer
      add :period_start, :integer
      add :period_end, :integer
      add :status, :string

      timestamps()
    end
  end
end
