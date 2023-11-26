# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.StreamerController do
  alias Streamaze.Finances
  use StreamazeWeb, :controller

  alias Streamaze.Streams

  def index(conn, %{"api_key" => api_key}) do
    try do
      detected_streamer_id = Streams.get_streamer_id_for_api_key(api_key)
      streamer = Streams.get_streamer!(detected_streamer_id)
      has_valid_subscription = Finances.has_valid_subscription?(streamer.user_id)

      render(conn, "show_private.json",
        streamer: streamer,
        has_valid_subscription: has_valid_subscription
      )
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
end
