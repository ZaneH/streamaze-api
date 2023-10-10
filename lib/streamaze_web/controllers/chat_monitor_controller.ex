defmodule StreamazeWeb.ChatMonitorController do
  alias Streamaze.Streams
  use StreamazeWeb, :controller
  require Logger

  def index(conn, _params) do
    chats = Streams.list_chat_monitors(conn.params["streamer_id"])
    render(conn, "index.json", chats: chats)
  end

  # TODO: Don't allow more than 1 to be created per 24hrs
  def create(conn, %{"streamaze_key" => streamaze_key}) do
    streamer_id = Streams.get_streamer_id_for_api_key(streamaze_key)
    live_stream_id = Streams.get_live_stream_by_streamer_id(streamer_id).id

    case create_chat_monitor(streamer_id, live_stream_id) do
      {:ok, chat_monitor} ->
        conn
        |> put_status(:created)
        |> render("show.json", chat_monitor: chat_monitor)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  defp create_chat_monitor(streamer_id, live_stream_id) do
    start_time = DateTime.utc_now()

    Streams.create_chat_monitor(%{
      "streamer_id" => streamer_id,
      "live_stream_id" => live_stream_id,
      "monitor_start" => start_time,
      "monitor_end" => start_time |> DateTime.add(24, :hour),
      "chat_activity" => %{}
    })
  end

  defp update_chat_monitor(chat_monitor, chat_activity) do
    new_activity = Map.merge(chat_monitor.chat_activity, chat_activity)

    Streams.update_chat_monitor(chat_monitor, %{
      "chat_activity" => new_activity
    })
  end

  defp create_or_get_chat_monitor(streamer_id, live_stream_id, chat_monitor \\ %{}) do
    if Map.get(chat_monitor, :monitor_start) < DateTime.utc_now() |> DateTime.add(-24, :hour) do
      case create_chat_monitor(streamer_id, live_stream_id) do
        {:ok, monitor} ->
          monitor

        {:error, _} ->
          Logger.warning(
            "Couldn't create new chat monitor. Using existing chat monitor #{inspect(chat_monitor)}"
          )

          chat_monitor
      end
    else
      chat_monitor
    end
  end

  # Update will be used to update chat_activity and add "segments"
  # If the chat_monitor is older than 24hrs, it will be closed and a new one will be created
  def update(conn, %{
        "id" => _id,
        "streamaze_key" => streamaze_key,
        "chat_activity" => chat_activity
      }) do
    streamer_id = Streams.get_streamer_id_for_api_key(streamaze_key)
    live_stream_id = Streams.get_live_stream_by_streamer_id(streamer_id).id

    case Streams.get_latest_chat_monitor(streamer_id) do
      nil ->
        new_chat_monitor = create_or_get_chat_monitor(streamer_id, live_stream_id)

        case update_chat_monitor(new_chat_monitor, chat_activity) do
          {:ok, chat_monitor} ->
            conn
            |> put_status(:ok)
            |> render("show.json", chat_monitor: chat_monitor)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", changeset: changeset)
        end

      chat_monitor ->
        new_chat_monitor = create_or_get_chat_monitor(streamer_id, live_stream_id, chat_monitor)

        case update_chat_monitor(new_chat_monitor, chat_activity) do
          {:ok, chat_monitor} ->
            conn
            |> put_status(:ok)
            |> render("show.json", chat_monitor: chat_monitor)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", changeset: changeset)
        end
    end
  end
end
