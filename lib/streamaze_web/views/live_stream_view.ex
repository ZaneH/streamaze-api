defmodule StreamazeWeb.LiveStreamView do
  use StreamazeWeb, :view

  def render("index.json", %{live_stream: live_stream}) do
    %{data: render_many(live_stream, StreamazeWeb.LiveStreamView, "show.json")}
  end

  def render("create.json", %{live_stream: live_stream}) do
    %{success: true, data: render_one(live_stream, StreamazeWeb.LiveStreamView, "show.json")}
  end

  def render("show.json", %{live_stream: live_stream}) do
    %{
      donation_goal: live_stream.donation_goal,
      donation_goal_currency: live_stream.donation_goal_currency,
      is_live: live_stream.is_live,
      is_subathon: live_stream.is_subathon,
      subathon_minutes_per_dollar: live_stream.subathon_minutes_per_dollar,
      subathon_seconds_added: live_stream.subathon_seconds_added,
      subathon_start_minutes: live_stream.subathon_start_minutes,
      subathon_start_time: live_stream.subathon_start_time,
      subathon_ended_time: live_stream.subathon_ended_time
    }
  end

  def render("update.json", %{live_stream: live_stream}) do
    %{success: true, data: render_one(live_stream, StreamazeWeb.LiveStreamView, "show.json")}
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
