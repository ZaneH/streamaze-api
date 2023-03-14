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
      streamlabs_token: streamer.streamlabs_token,
      lanyard_api_key: streamer.lanyard_api_key,
      discord_id: streamer.discord_id
    }
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
