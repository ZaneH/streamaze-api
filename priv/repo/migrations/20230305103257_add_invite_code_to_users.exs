defmodule Streamaze.Repo.Migrations.AddInviteCodeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :invite_code, :string
    end
  end
end
