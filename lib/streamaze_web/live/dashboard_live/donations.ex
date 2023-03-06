defmodule StreamazeWeb.DashboardLive.Donations do
  alias Streamaze.Finances
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    donations = Finances.list_streamer_donations(params["streamer_id"])

    {:noreply,
     socket |> assign(:page_title, "Streamer Donations") |> assign(:all_donations, donations)}
  end
end
