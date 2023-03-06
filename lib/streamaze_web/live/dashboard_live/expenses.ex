defmodule StreamazeWeb.DashboardLive.Expenses do
  alias Streamaze.Finances
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    expenses = Finances.list_streamer_expenses(params["streamer_id"])

    {:noreply,
     socket |> assign(:page_title, "Streamer Expenses") |> assign(:all_expenses, expenses)}
  end
end
