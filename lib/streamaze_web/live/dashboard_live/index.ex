defmodule StreamazeWeb.DashboardLive.Index do
  alias Streamaze.Streams
  alias Streamaze.Finances
  use StreamazeWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    if is_nil(params["streamer_id"]) do
      {:ok, push_redirect(socket, to: "/")}
    else
      selected_streamer = Streams.get_streamer!(params["streamer_id"])

      active_streams = Streams.list_active_live_streams(selected_streamer.id)
      inactive_streams = Streams.list_inactive_live_streams(selected_streamer.id)

      expenses = Finances.list_streamer_expenses(selected_streamer.id)

      donations = Finances.list_streamer_donations(selected_streamer.id)

      {:ok,
       assign(socket, :selected_streamer, selected_streamer)
       |> assign(:live_streams, active_streams)
       |> assign(:streamer_expenses, expenses)
       |> assign(:latest_donations, donations)
       |> assign(:latest_inactive_streams, inactive_streams)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Dashboard")
  end
end
