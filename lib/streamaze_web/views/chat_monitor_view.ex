defmodule StreamazeWeb.ChatMonitorView do
  use StreamazeWeb, :view

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, StreamazeWeb.ChatMonitorView, "show.json")}
  end

  def render("create.json", %{chat_monitor: chat}) do
    %{success: true, data: render_one(chat, StreamazeWeb.ChatMonitorView, "show.json")}
  end

  def render("show.json", %{chat_monitor: chat}) do
    %{
      id: chat.id,
      streamer_id: chat.streamer_id,
      live_stream_id: chat.live_stream_id,
      monitor_start: chat.monitor_start,
      monitor_end: chat.monitor_end,
      chat_activity: chat.chat_activity,
      created_at: chat.inserted_at,
      updated_at: chat.updated_at
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      success: false,
      errors:
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)
    }
  end

  def render("error.json", %{error: error}) do
    %{success: false, error: error}
  end
end
