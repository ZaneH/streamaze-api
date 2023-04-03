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

    {:ok, body} = TTS.text_to_speech(text, voice_id, elevenlabs_key)

    S3.put_object("elevenlabsaudio", "tts/clip_test.mp3", body)
    |> ExAws.request!()

    s3_url =
      ExAws.Config.new(:s3)
      |> S3.presigned_url(:get, "elevenlabsaudio", "tts/clip_test.mp3", expires_in: 14_400)

    case s3_url do
      {:ok, tts_url} ->
        conn |> put_status(:ok) |> render("create.json", %{speak_url: tts_url})

      {:error, error} ->
        conn |> put_status(:not_found) |> render("error.json", error: error)
    end
  end
end
