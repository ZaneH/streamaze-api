defmodule Streamaze.Giveaways do
  import Ecto.Query, warn: false
  alias Streamaze.Repo

  alias Streamaze.Giveaways.GiveawayEntry

  def list_giveaway_entries(streamer_id, limit) do
    limit = max(1, min(100, limit))

    query =
      from g in GiveawayEntry,
        where: g.streamer_id == ^streamer_id,
        where: g.win_count < 1,
        order_by: [desc: g.id],
        limit: ^limit

    Repo.all(query)
  end

  def list_giveaways(streamer_id) do
    query =
      from g in GiveawayEntry,
        where: g.streamer_id == ^streamer_id,
        where: g.win_count < 1,
        where: not is_nil(g.chat_username),
        order_by: [desc: g.inserted_at]

    Repo.all(query)
  end

  def insert_giveaway_entry(streamer_id, entry_username) do
    giveaway_entry =
      %GiveawayEntry{
        streamer_id: streamer_id,
        entry_username: entry_username,
        win_count: 0
      }

    giveaway_entry
    |> GiveawayEntry.changeset()
    |> Repo.insert()
  end

  def get_giveaway_entry!(id) do
    Repo.get!(GiveawayEntry, id)
  end

  def get_giveaway_entry_by_entry_username(entry_username) do
    query =
      from g in GiveawayEntry,
        where: g.entry_username == ^entry_username

    Repo.one(query)
  end

  def update_giveaway_entry(giveaway_entry, params) do
    giveaway_entry
    |> GiveawayEntry.changeset(params)
    |> Repo.update()
  end

  def assign_chat_name_to_giveaway_entry(giveaway_entry, username) do
    case giveaway_entry.chat_username do
      nil ->
        result =
          giveaway_entry
          |> GiveawayEntry.changeset(%{chat_username: username})
          |> Repo.update()

        case result do
          {:ok, giveaway_entry} ->
            {:ok, giveaway_entry}

          {:error, changeset} ->
            {:error, %{changeset: changeset}}
        end

      _ ->
        {:error, "This entry name has been claimed already."}
    end
  end

  def reset_giveaway(streamer_id) do
    query =
      from g in GiveawayEntry,
        where: g.streamer_id == ^streamer_id,
        order_by: [desc: g.inserted_at]

    giveaway_entries = Repo.all(query)

    giveaway_entries
    |> Enum.map(fn giveaway_entry ->
      giveaway_entry
      |> GiveawayEntry.changeset(%{win_count: 0, chat_username: nil})
      |> Repo.update()
    end)
  end
end
