defmodule Streamaze.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :amount, :float
      add :currency, :string
      add :streamer_id, references(:streamers, on_delete: :nothing)

      timestamps()
    end

    create index(:expenses, [:streamer_id])
  end
end
