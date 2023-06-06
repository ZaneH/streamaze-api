defmodule StreamazeWeb.GiveawayEntryView do
  use StreamazeWeb, :view

  def render("index.json", %{giveaway_entry: giveaway_entry}) do
    %{data: render_many(giveaway_entry, StreamazeWeb.GiveawayEntryView, "show.json")}
  end

  def render("create.json", %{giveaway_entry: giveaway_entry}) do
    %{
      success: true,
      data: render_one(giveaway_entry, StreamazeWeb.GiveawayEntryView, "show.json")
    }
  end

  def render("show.json", %{giveaway_entry: giveaway_entry}) do
    %{
      id: giveaway_entry.id,
      entry_username: giveaway_entry.entry_username
    }
  end
end
