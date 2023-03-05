defmodule StreamazeWeb.ManagersLive.Index do
  alias Streamaze.Streams
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    form = %{
      invite_code: ""
    }

    managers = Accounts.list_streamers_for_manager(socket.assigns.current_user.id)
    streamer_name = Streams.get_streamer_for_user!(socket.assigns.current_user.id).name

    {:ok,
     assign(socket, :managers, managers)
     |> assign(:streamer_name, streamer_name)
     |> assign(:form, form)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "New Streamer")
  end
end
