defmodule StreamazeWeb.ChatMonitorController do
  alias Streamaze.Streams
  use StreamazeWeb, :controller

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
        |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: changeset)
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
    new_activity =
      Map.merge(chat_monitor.chat_activity, chat_activity)

    Streams.update_chat_monitor(chat_monitor, %{
      "chat_activity" => new_activity
    })
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
        conn
        |> put_status(:not_found)
        |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: nil)

      chat_monitor ->
        new_chat_monitor =
          if chat_monitor.monitor_start < DateTime.utc_now() |> DateTime.add(-24, :hour) do
            IO.puts("Creating new chat monitor from update")

            case create_chat_monitor(streamer_id, live_stream_id) do
              {:ok, monitor} ->
                monitor

              {:error, _} ->
                IO.puts(
                  "Error creating new chat monitor from update. Using existing chat monitor #{inspect(chat_monitor)}"
                )

                chat_monitor
            end
          else
            IO.puts("Using existing chat monitor #{inspect(chat_monitor)}")
            chat_monitor
          end

        case update_chat_monitor(new_chat_monitor, chat_activity) do
          {:ok, chat_monitor} ->
            conn
            |> put_status(:ok)
            |> render("show.json", chat_monitor: chat_monitor)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(StreamazeWeb.ChatMonitorView, "error.json", changeset: changeset)
        end
    end
  end
end
