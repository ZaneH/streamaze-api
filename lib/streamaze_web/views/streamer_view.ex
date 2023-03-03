defmodule StreamazeWeb.StreamerView do
  use StreamazeWeb, :view

  def render("index.json", %{streamers: streamers}) do
    streamers
    |> Enum.map(fn streamer ->
      %{
        id: streamer.id,
        name: streamer.name,
        youtube_url: streamer.youtube_url
      }
    end)
  end

  def render("show.json", %{streamer: streamer}) do
    %{
      success: true,
      data: %{
        id: streamer.id,
        name: streamer.name,
        youtube_url: streamer.youtube_url
      }
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
end
