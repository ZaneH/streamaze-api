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

  def render("update.json", %{giveaway_entry: giveaway_entry}) do
    %{
      success: true,
      data: render_one(giveaway_entry, StreamazeWeb.GiveawayEntryView, "show.json")
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

  def render("update.txt", %{giveaway_entry: giveaway_entry}) do
    "Giveaway entry updated: @#{giveaway_entry.chat_username} -> #{giveaway_entry.entry_username}"
  end

  def render("error.txt", %{error: error}) do
    "Error: #{error}"
  end
end
