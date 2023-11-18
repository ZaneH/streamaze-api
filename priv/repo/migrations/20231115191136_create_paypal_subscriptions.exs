defmodule Streamaze.Repo.Migrations.CreatePaypalSubscriptions do
  use Ecto.Migration

  def change do
    create table(:paypal_subscriptions) do
      add :subscription_id, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :item_id, :string

      timestamps()
    end
  end
end
