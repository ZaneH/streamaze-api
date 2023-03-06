defmodule StreamazeWeb.ProfileLive.Index do
  alias Streamaze.Accounts
  alias Streamaze.Streams
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    streamer = Streams.get_streamer_for_user(socket.assigns.current_user.id)
    {:ok, assign(socket, :streamer, streamer)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Profile")
  end
end
