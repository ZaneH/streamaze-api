defmodule StreamazeWeb.DashboardController do
  use StreamazeWeb, :controller

  def index(conn, _params) do
    managed_streamers =
      Streamaze.Accounts.list_streamers_for_manager(conn.assigns.current_user.id)

    render(conn, "index.html", managed_streamers: managed_streamers)
  end
end
