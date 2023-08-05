defmodule StreamazeWeb.UploadController do
  alias Streamaze.Streams
  use StreamazeWeb, :controller
  alias ExAws.S3

  def upload(conn, %{"api_key" => api_key, "type" => "alert"}) do
    streamer_id = Streams.get_streamer_id_for_api_key(api_key)
    streamer = Streams.get_streamer!(streamer_id)

    delete_existing_s3_file(streamer.donation_audio_s3)

    {:ok, file_body, conn} = read_body(conn, length: 10_000_000)

    if file_body == "" do
      delete_existing_s3_file(streamer.donation_audio_s3)
      Streams.update_streamer(streamer, %{donation_audio_s3: nil})
      render(conn, "success.json", success: true)
    else
      case upload_to_s3(file_body, streamer_id) do
        {:ok, file_name} ->
          case Streams.update_streamer(streamer, %{donation_audio_s3: file_name}) do
            {:ok, _} ->
              render(conn, "success.json", success: true)

            {:error, error} ->
              render(conn, "error.json", error: error)
          end

        {:error, error} ->
          render(conn, "error.json", error: error)
      end
    end
  end

  defp delete_existing_s3_file(file_name) do
    try do
      S3.delete_object("streameraudio", file_name)
      |> ExAws.request!()

      :ok
    rescue
      error ->
        {:error, error}
    end
  end

  defp upload_to_s3(body, streamer_id) do
    file_name = "alerts/alert_for_#{streamer_id}_#{System.os_time(:millisecond)}.mp3"

    try do
      S3.put_object("streameraudio", file_name, body)
      |> ExAws.request!()

      {:ok, file_name}
    rescue
      error ->
        {:error, error}
    end
  end
end
