defmodule Streamaze.Repo.Migrations.AddApiKeyToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :api_key, :string
    end

    create index(:users, [:api_key], unique: true)
  end
end
