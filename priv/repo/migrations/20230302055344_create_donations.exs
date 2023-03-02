defmodule Streamaze.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :float
      add :currency, :string
      add :sender, :string
      add :message, :string
      add :metadata, :map
      add :type, :string
      add :streamer_id, references(:streamers, on_delete: :nothing)

      timestamps()
    end

    create index(:donations, [:streamer_id])
  end
end
