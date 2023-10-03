defmodule StreamazeWeb.ChatMonitorController do
  alias Streamaze.Streams
  use StreamazeWeb, :controller

  def index(conn, _params) do
    chats = Streams.list_chat_monitors(conn.params["streamer_id"])
    render(conn, "index.json", chats: chats)
  end

  # TODO: Don't allow more than 1 to be created per 24hrs
  def create(conn, %{"streamazeKey" => streamaze_key}) do
    streamer_id = Streams.get_streamer_id_for_api_key(streamaze_key)
    live_stream_id = Streams.get_live_stream_by_streamer_id(streamer_id).id

    case Streams.create_chat_monitor(%{
           "streamer_id" => streamer_id,
           "live_stream_id" => live_stream_id,
           "monitor_start" => DateTime.utc_now(),
           "chat_activity" => %{}
         }) do
      {:ok, chat_monitor} ->
        conn
        |> put_status(:created)
        |> render("show.json", chat_monitor: chat_monitor)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: changeset)
    end
  end

  # Update will be used to update chat_activity and add "segments"
  # If the chat_monitor is older than 24hrs, it will be closed and a new one will be created
  def update(conn, %{
        "streamaze_key" => streamaze_key,
        "id" => id,
        "chat_activity" => chat_activity
      }) do
    streamer_id = Streams.get_streamer_id_for_api_key(streamaze_key)
    live_stream_id = Streams.get_live_stream_by_streamer_id(streamer_id).id

    case Streams.get_chat_monitor(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: nil)

      chat_monitor ->
        case Streams.update_chat_monitor(chat_monitor, %{
               "streamer_id" => streamer_id,
               "live_stream_id" => live_stream_id,
               "monitor_start" => DateTime.utc_now(),
               "chat_activity" => chat_activity
             }) do
          {:ok, chat_monitor} ->
            conn
            |> put_status(:created)
            |> render("show.json", chat_monitor: chat_monitor)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: changeset)
        end
    end
  end
end
