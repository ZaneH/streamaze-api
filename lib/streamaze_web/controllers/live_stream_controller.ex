# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.LiveStreamController do
  use StreamazeWeb, :controller

  alias Streamaze.Streams

  def index(conn, %{"api_key" => api_key}) do
    try do
      detected_streamer_id = Streams.get_streamer_id_for_api_key(api_key)
      live_stream = Streams.get_live_stream_by_streamer_id(detected_streamer_id)
      render(conn, "index.json", live_stream: [live_stream])
    rescue
      _ in Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Live stream not found")
    end
  end

  def index(conn, _params) do
    live_streams = Streams.list_live_streams()
    render(conn, "index.json", live_stream: live_streams)
  end

  def create(conn, params) do
    case Streams.create_live_stream(params) do
      {:ok, live_stream} ->
        conn
        |> put_status(:created)
        |> render("create.json", live_stream: live_stream)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    live_stream = Streams.get_live_stream!(conn.params["id"])

    case Streams.update_live_stream(live_stream, params) do
      {:ok, live_stream} ->
        broadcast_subathon_update(live_stream)

        conn
        |> put_status(:created)
        |> render("update.json", live_stream: live_stream)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, _params) do
    try do
      live_stream = Streams.get_live_stream!(conn.params["id"])
      render(conn, "show.json", live_stream: live_stream)
    rescue
      _ in Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Live stream not found")
    end
  end

  defp broadcast_subathon_update(live_stream) do
    StreamazeWeb.Endpoint.broadcast("streamer:#{live_stream.streamer_id}", "subathon", %{
      id: live_stream.id,
      subathon_seconds_added: live_stream.subathon_seconds_added,
      subathon_start_time: live_stream.subathon_start_time,
      subathon_start_minutes: live_stream.subathon_start_minutes,
      subathon_ended_time: live_stream.subathon_ended_time,
      subathon_minutes_per_dollar: live_stream.subathon_minutes_per_dollar
    })
  end
end
