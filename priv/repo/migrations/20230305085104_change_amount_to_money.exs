defmodule Streamaze.Repo.Migrations.ChangeAmountToMoney do
  use Ecto.Migration

  def up do
    alter table(:donations) do
      remove :amount
      remove :currency
      add :amount, :money_with_currency
    end

    alter table(:expenses) do
      remove :amount
      remove :currency
      add :amount, :money_with_currency
    end
  end

  def down do
    alter table(:donations) do
      remove :amount
      add :amount, :float
      add :currency, :string
    end

    alter table(:expenses) do
      remove :amount
      add :amount, :float
      add :currency, :string
    end
  end
end
