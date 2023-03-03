defmodule StreamazeWeb.LiveStreamController do
  use StreamazeWeb, :controller

  alias Streamaze.Streams

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

  def update(conn, %{"id" => id, "live_stream" => live_stream_params}) do
    case Streams.update_live_stream(id, live_stream_params) do
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
end
