defmodule StreamazeWeb.VoiceView do
  use StreamazeWeb, :view

  def render("show.json", %{voice: voice}) do
    %{id: voice["voice_id"], name: voice["name"], preview_url: voice["preview_url"]}
  end
end
