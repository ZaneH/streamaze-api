defmodule StreamazeWeb.GiveawayController do
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
end
