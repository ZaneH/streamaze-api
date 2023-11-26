# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Payments.StripeInvoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stripe_invoices" do
    field :stripe_id, :string
    field :amount_due, :integer
    field :amount_paid, :integer
    field :amount_remaining, :integer
    field :currency, :string
    field :date, :integer
    field :period_start, :integer
    field :period_end, :integer
    field :status, :string

    belongs_to :stripe_customer, Streamaze.Payments.StripeCustomer, foreign_key: :customer_id

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :stripe_id,
      :customer_id,
      :amount_due,
      :amount_paid,
      :amount_remaining,
      :currency,
      :date,
      :period_start,
      :period_end,
      :status
    ])
    |> validate_required([
      :stripe_id,
      :customer_id,
      :amount_due,
      :amount_paid,
      :amount_remaining,
      :currency,
      :date,
      :period_start,
      :period_end,
      :status
    ])
    |> foreign_key_constraint(:customer_id)
  end
end
