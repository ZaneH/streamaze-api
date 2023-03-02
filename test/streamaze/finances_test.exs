defmodule Streamaze.FinancesTest do
  use Streamaze.DataCase

  alias Streamaze.Finances

  describe "expenses" do
    alias Streamaze.Finances.Expense

    import Streamaze.FinancesFixtures

    @invalid_attrs %{amount: nil, currency: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Finances.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Finances.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{amount: 120.5, currency: "some currency"}

      assert {:ok, %Expense{} = expense} = Finances.create_expense(valid_attrs)
      assert expense.amount == 120.5
      assert expense.currency == "some currency"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finances.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{amount: 456.7, currency: "some updated currency"}

      assert {:ok, %Expense{} = expense} = Finances.update_expense(expense, update_attrs)
      assert expense.amount == 456.7
      assert expense.currency == "some updated currency"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Finances.update_expense(expense, @invalid_attrs)
      assert expense == Finances.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Finances.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Finances.change_expense(expense)
    end
  end

  describe "donations" do
    alias Streamaze.Finances.Donation

    import Streamaze.FinancesFixtures

    @invalid_attrs %{amount: nil, currency: nil, message: nil, metadata: nil, sender: nil, type: nil}

    test "list_donations/0 returns all donations" do
      donation = donation_fixture()
      assert Finances.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id" do
      donation = donation_fixture()
      assert Finances.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation" do
      valid_attrs = %{amount: 120.5, currency: "some currency", message: "some message", metadata: %{}, sender: "some sender", type: "some type"}

      assert {:ok, %Donation{} = donation} = Finances.create_donation(valid_attrs)
      assert donation.amount == 120.5
      assert donation.currency == "some currency"
      assert donation.message == "some message"
      assert donation.metadata == %{}
      assert donation.sender == "some sender"
      assert donation.type == "some type"
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finances.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation" do
      donation = donation_fixture()
      update_attrs = %{amount: 456.7, currency: "some updated currency", message: "some updated message", metadata: %{}, sender: "some updated sender", type: "some updated type"}

      assert {:ok, %Donation{} = donation} = Finances.update_donation(donation, update_attrs)
      assert donation.amount == 456.7
      assert donation.currency == "some updated currency"
      assert donation.message == "some updated message"
      assert donation.metadata == %{}
      assert donation.sender == "some updated sender"
      assert donation.type == "some updated type"
    end

    test "update_donation/2 with invalid data returns error changeset" do
      donation = donation_fixture()
      assert {:error, %Ecto.Changeset{}} = Finances.update_donation(donation, @invalid_attrs)
      assert donation == Finances.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{}} = Finances.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset" do
      donation = donation_fixture()
      assert %Ecto.Changeset{} = Finances.change_donation(donation)
    end
  end
end
