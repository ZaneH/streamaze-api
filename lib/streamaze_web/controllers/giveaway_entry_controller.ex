defmodule StreamazeWeb.GiveawayEntryController do
  use StreamazeWeb, :controller

  alias Streamaze.Giveaways

  def index(conn, %{"api_key" => api_key}) do
    try do
      detected_streamer_id = Streamaze.Streams.get_streamer_id_for_api_key(api_key)
      streamer = Streamaze.Streams.get_streamer!(detected_streamer_id)

      render(conn, "index.json", giveaway_entry: Giveaways.list_giveaways(streamer.id))
    rescue
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Giveaway not found")
    end
  end

  def update(conn, params) do
    giveaway_entry = Giveaways.get_giveaway_entry!(conn.params["id"])

    case Giveaways.update_giveaway_entry(giveaway_entry, params) do
      {:ok, giveaway_entry} ->
        conn
        |> put_status(:created)
        |> render("update.json", giveaway_entry: giveaway_entry)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
