defmodule StreamazeWeb.AlertAudioController do
  alias ExAws.S3

  def get_signed_alert_audio_url(nil) do
    get_signed_alert_audio_url("alerts/default.mp3")
  end

  def get_signed_alert_audio_url(file_name) do
    {:ok, s3_url} =
      ExAws.Config.new(:s3)
      |> S3.presigned_url(
        :get,
        "streameraudio",
        file_name,
        # 7 days (max)
        expires_in: 7 * 24 * 60 * 60
      )

    s3_url
  end
end
