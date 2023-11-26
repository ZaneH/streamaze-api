# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.CreatePaypalEvents do
  use Ecto.Migration

  def change do
    create table(:paypal_events) do
      add :event_type, :string, null: false
      add :event_id, :string, null: false
      add :raw_body, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
