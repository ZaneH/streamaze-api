defmodule Streamaze.Repo.Migrations.AddAmountInUsd do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :amount_in_usd, :float
    end

    alter table(:donations) do
      add :amount_in_usd, :float
    end
  end
end
