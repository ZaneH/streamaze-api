# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddChatUsernameToGiveawayEntry do
  use Ecto.Migration

  def change do
    alter table(:giveaway_entries) do
      add :chat_username, :string
    end
  end
end
