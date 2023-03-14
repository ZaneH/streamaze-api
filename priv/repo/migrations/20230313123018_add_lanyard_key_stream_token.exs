defmodule Streamaze.Repo.Migrations.AddLanyardKeyStreamToken do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :streamlabs_token, :text
      add :lanyard_api_key, :string
      add :discord_id, :string
    end
  end
end
