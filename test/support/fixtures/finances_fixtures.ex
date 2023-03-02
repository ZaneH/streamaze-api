defmodule Streamaze.FinancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Streamaze.Finances` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        currency: "some currency"
      })
      |> Streamaze.Finances.create_expense()

    expense
  end

  @doc """
  Generate a donation.
  """
  def donation_fixture(attrs \\ %{}) do
    {:ok, donation} =
      attrs
      |> Enum.into(%{
        amount: 120.5,
        currency: "some currency",
        message: "some message",
        metadata: %{},
        sender: "some sender",
        type: "some type"
      })
      |> Streamaze.Finances.create_donation()

    donation
  end
end
