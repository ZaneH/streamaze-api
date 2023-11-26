# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Repo.Migrations.AddDonationAudioS3ToStreamer do
  use Ecto.Migration

  def change do
    alter table(:streamers) do
      add :donation_audio_s3, :string
    end
  end
end
