defmodule Streamaze.Repo.Migrations.AddExcludeFromProfitToDonations do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :exclude_from_profit, :boolean, default: false
    end
  end
end
