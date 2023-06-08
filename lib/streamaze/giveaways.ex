defmodule Streamaze.Giveaways do
  import Ecto.Query, warn: false
  alias Streamaze.Repo

  alias Streamaze.Giveaways.GiveawayEntry

  def list_giveaways(streamer_id) do
    query =
      from g in GiveawayEntry,
        where: g.streamer_id == ^streamer_id,
        where: g.win_count <= 0,
        order_by: [desc: g.inserted_at]

    Repo.all(query)
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
          {:ok, _} ->
            {:ok, giveaway_entry}

          {:error, _} ->
            {:error, "Something went wrong. Try again?"}
        end

      _ ->
        {:error, "This entry name has been claimed already."}
    end
  end
end
