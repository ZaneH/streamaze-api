defmodule StreamazeWeb.StreamerController do
  use StreamazeWeb, :controller

  alias Streamaze.Streams
  alias Streamaze.TTS

  def index(conn, %{"api_key" => api_key}) do
    try do
      detected_streamer_id = Streams.get_streamer_id_for_api_key(api_key)
      streamer = Streams.get_streamer!(detected_streamer_id)

      render(conn, "show_private.json", streamer: streamer)
    rescue
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Streamer not found")
    end
  end

  def index(conn, _params) do
    streamers = Streams.list_streamers()
    render(conn, "index.json", streamers: streamers)
  end

  def create(conn, params) do
    case Streams.create_streamer(params) do
      {:ok, streamer} ->
        conn
        |> put_status(:created)
        |> render("create.json", streamer: streamer)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    streamer = Streams.get_streamer!(conn.params["id"])

    case Streams.update_streamer(streamer, params) do
      {:ok, streamer} ->
        conn
        |> put_status(:created)
        |> render("update.json", streamer: streamer)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def voices(conn, _) do
    streamer_id = Streams.get_streamer_id_for_api_key(conn.params["api_key"])
    streamer = Streams.get_streamer!(streamer_id)

    case streamer.donations_config do
      %{"elevenlabs_key" => elevenlabs_key} when elevenlabs_key != "" ->
        voices = TTS.available_voices(elevenlabs_key)

        conn |> put_status(:ok) |> render("voices.json", voices: voices)

      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "ElevenLabs not configured for streamer")
    end
  end
end
