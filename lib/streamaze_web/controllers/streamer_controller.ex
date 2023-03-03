defmodule StreamazeWeb.StreamerController do
  use StreamazeWeb, :controller

  alias Streamaze.Streams

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
end
