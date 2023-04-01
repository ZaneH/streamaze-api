defmodule StreamazeWeb.StreamerView do
  use StreamazeWeb, :view

  def render("index.json", %{streamers: streamers}) do
    %{data: render_many(streamers, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("create.json", %{streamer: streamer}) do
    %{success: true, data: render_one(streamer, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("show.json", %{streamer: streamer}) do
    %{
      id: streamer.id,
      name: streamer.name,
      youtube_url: streamer.youtube_url
    }
  end

  def render("show_private.json", %{streamer: streamer}) do
    %{
      id: streamer.id,
      name: streamer.name,
      youtube_url: streamer.youtube_url,
      chat_config: streamer.chat_config,
      clip_config: streamer.clip_config,
      obs_config: streamer.obs_config,
      viewers_config: streamer.viewers_config,
      donations_config: streamer.donations_config,
      lanyard_config: streamer.lanyard_config
    }
  end

  def render("voices.json", %{voices: voices}) do
    %{data: render_many(voices, StreamazeWeb.VoiceView, "show.json")}
  end

  def render("update.json", %{streamer: streamer}) do
    %{success: true, data: render_one(streamer, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("error.json", %{error: error}) do
    %{success: false, error: error}
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
end
