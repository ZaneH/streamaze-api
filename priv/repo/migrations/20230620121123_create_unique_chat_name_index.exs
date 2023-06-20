defmodule Streamaze.Repo.Migrations.CreateUniqueChatNameIndex do
  use Ecto.Migration

  def change do
    create unique_index(:giveaway_entries, [:chat_username])
  end
end
