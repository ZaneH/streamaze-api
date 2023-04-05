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

    {text, voice_id} = get_voice_from_prefix(text, voice_id)
    audio = TTS.text_to_speech(text, voice_id, elevenlabs_key)

    case audio do
      {:ok, body} ->
        url = upload_to_s3(body, streamer_id, voice_id)
        conn |> put_status(:ok) |> render("create.json", %{speak_url: url})

      {:error, error} ->
        IO.inspect(error)
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
        expires_in: 72 * 60 * 60
      )

    s3_url
  end

  defp get_voice_from_prefix(text, voice_id) do
    text = String.downcase(text)

    cond do
      String.contains?(text, "!sus ") ->
        {String.replace(text, "!sus ", ""), "yr6Duy4g20vOOalAiZzF"}

      String.contains?(text, "!evan ") ->
        {String.replace(text, "!evan ", ""), "409nTFdZtB7GNYnKzLQF"}

      String.contains?(text, "!ice ") ->
        {String.replace(text, "!ice ", ""), "9FgctjpXeaMlm2WRPCFs"}

      String.contains?(text, "!ebz ") ->
        {String.replace(text, "!ebz ", ""), "cgZyzakA6d8LhJghycoW"}

      String.contains?(text, "!blade") ->
        {String.replace(text, "!blade", ""), "JSLeek4NxMXrwdx8iiZU"}

      String.contains?(text, "!gary ") ->
        {String.replace(text, "!gary ", ""), "1gE8msxAuJeZQhv3KuEy"}

      String.contains?(text, "!cas ") ->
        {String.replace(text, "!cas ", ""), "NxuFIYd0d676kT8kaykv"}

      String.contains?(text, "!ttd ") ->
        {String.replace(text, "!ttd ", ""), "iaQLOQPURshhG5sGOumZ"}

      String.contains?(text, "!kim ") ->
        {String.replace(text, "!kim ", ""), "jJTBoKoKygVt4bRIQA8k"}

      true ->
        {text, voice_id}
    end
  end
end
