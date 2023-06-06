defmodule Streamaze.Giveaways do
  import Ecto.Query, warn: false
  alias Streamaze.Repo

  alias Streamaze.Giveaways.GiveawayEntry

  def list_giveaways(streamer_id) do
    query =
      from g in GiveawayEntry,
        where: g.streamer_id == ^streamer_id,
        order_by: [desc: g.inserted_at]

    Repo.all(query)
  end

  def get_giveaway_entry!(id) do
    Repo.get!(GiveawayEntry, id)
  end

  def update_giveaway_entry(giveaway_entry, params) do
    giveaway_entry
    |> GiveawayEntry.changeset(params)
    |> Repo.update()
  end
end
