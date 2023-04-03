defmodule StreamazeWeb.TTSController do
  use StreamazeWeb, :controller

  alias ExAws.S3
  alias Streamaze.TTS
  alias Streamaze.Streams

  def index(conn, _params) do
    streamer_id = Streams.get_streamer_id_for_api_key(conn.params["api_key"])
    streamer = Streams.get_streamer!(streamer_id)

    case streamer.donations_config do
      %{"elevenlabs_key" => elevenlabs_key} when elevenlabs_key != "" ->
        voices = TTS.list_voices(elevenlabs_key)

        conn |> put_status(:ok) |> render("voices.json", tts: voices)

      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "ElevenLabs not configured for streamer")
    end
  end

  def create(conn, %{
        "text" => text,
        "api_key" => api_key
      }) do
    streamer_id = Streams.get_streamer_id_for_api_key(api_key)
    streamer = Streams.get_streamer!(streamer_id)

    voice_id = streamer.donations_config["elevenlabs_voice"]
    elevenlabs_key = streamer.donations_config["elevenlabs_key"]

    audio = TTS.text_to_speech(text, voice_id, elevenlabs_key)

    case audio do
      {:ok, body} ->
        url = upload_to_s3(body, streamer_id, voice_id)
        conn |> put_status(:ok) |> render("create.json", %{speak_url: url})

      {:error, error} ->
        conn |> put_status(:not_found) |> render("error.json", error: error)
    end
  end

  defp upload_to_s3(body, streamer_id, voice_id) do
    file_name = "tts/clip_#{streamer_id}_#{voice_id}_#{System.os_time(:millisecond)}.mp3"

    S3.put_object("elevenlabsaudio", file_name, body)
    |> ExAws.request!()

    {:ok, s3_url} =
      ExAws.Config.new(:s3)
      |> S3.presigned_url(
        :get,
        "elevenlabsaudio",
        file_name,
        expires_in: 14_400
      )

    s3_url
  end
end
