defmodule Streamaze.Repo.Migrations.RenameAmountToValue do
  use Ecto.Migration

  def up do
    rename table(:expenses), :amount, to: :value
    rename table(:donations), :amount, to: :value
  end

  def down do
    rename table(:expenses), :value, to: :amount
    rename table(:donations), :value, to: :amount
  end
end
