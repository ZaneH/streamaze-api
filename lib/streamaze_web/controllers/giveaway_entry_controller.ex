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

  def assign_chat_name(conn, params) do
    entry_username = params["entry_username"]
    chat_username = params["chat_username"]

    case Giveaways.get_giveaway_entry_by_entry_username(entry_username) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("error.txt", error: "Giveaway entry not found")

      giveaway_entry ->
        case Giveaways.assign_chat_name_to_giveaway_entry(giveaway_entry, chat_username) do
          {:ok, giveaway_entry} ->
            conn
            |> put_status(:created)
            |> render("update.txt", giveaway_entry: giveaway_entry)

          {:error, error} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.txt", error: error)
        end
    end
  end
end
