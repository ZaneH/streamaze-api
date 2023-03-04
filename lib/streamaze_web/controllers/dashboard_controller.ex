defmodule StreamazeWeb.DashboardController do
  use StreamazeWeb, :controller
  import StreamazeWeb.UserAuth

  plug :require_authenticated_user
  plug :put_layout, {StreamazeWeb.LayoutView, :dashboard}

  def index(conn, params) do
    managed_streamers =
      Streamaze.Accounts.list_streamers_for_manager(conn.assigns.current_user.id)

    selected_streamer =
      case params["streamer_id"] do
        nil ->
          nil

        streamer_id ->
          Streamaze.Streams.get_streamer!(streamer_id)
      end

    selected_streamer_id =
      case selected_streamer do
        nil -> nil
        streamer -> streamer.id
      end

    live_streams =
      case selected_streamer do
        nil -> []
        streamer -> Streamaze.Streams.list_active_live_streams(streamer.id)
      end

    streamer_expenses =
      case selected_streamer do
        nil -> []
        streamer -> Streamaze.Finances.list_streamer_expenses(streamer.id)
      end

    latest_donations =
      case selected_streamer do
        nil -> []
        streamer -> Streamaze.Finances.list_streamer_donations(streamer.id)
      end

    latest_inactive_streams =
      case selected_streamer do
        nil -> []
        streamer -> Streamaze.Streams.list_inactive_live_streams(streamer.id)
      end

    render(conn, "index.html",
      managed_streamers: managed_streamers,
      live_streams: live_streams,
      selected_streamer: selected_streamer,
      streamer_expenses: streamer_expenses,
      latest_donations: latest_donations,
      latest_inactive_streams: latest_inactive_streams,
      selected_streamer_id: selected_streamer_id
    )
  end
end
