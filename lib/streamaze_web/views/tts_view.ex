defmodule StreamazeWeb.TTSView do
  use StreamazeWeb, :view

  def render("voices.json", %{tts: tts}) do
    %{data: render_many(tts, StreamazeWeb.TTSView, "show_voices.json")}
  end

  def render("show_voices.json", %{tts: tts}) do
    %{id: tts["voice_id"], name: tts["name"], preview_url: tts["preview_url"]}
  end

  def render("audio.json", %{tts: tts}) do
    %{data: render_one(tts, StreamazeWeb.TTSView, "show_audio.json")}
  end

  def render("show_audio.json", %{tts: tts}) do
    %{speak_url: tts.speak_url}
  end

  def render("create.json", tts) do
    %{success: true, data: render_one(tts, StreamazeWeb.TTSView, "show_audio.json")}
  end

  def render("error.json", %{error: error}) do
    %{success: false, error: error}
  end
end
