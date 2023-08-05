defmodule StreamazeWeb.ManagersLive.Index do
  alias Streamaze.Streams
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    form = %{
      "invite_code" => ""
    }

    managers = Accounts.list_streamers_for_manager(socket.assigns.current_user.id)

    {:ok,
     assign(socket, :managers, managers)
     |> assign(:form, form)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("save", %{"invite_code" => invite_code}, socket) do
    streamer = Streams.get_streamer_for_user(socket.assigns.current_user.id)

    if streamer == nil do
      {:noreply,
       socket
       |> put_flash(:error, "You must have a streamer account to add managers")
       |> push_redirect(to: "/invite/managers")}
    else
      case Streams.add_manager_to_streamer(invite_code, streamer.id) do
        {:ok, _manager} ->
          {:noreply,
           socket
           |> put_flash(:info, "Added manager")
           |> push_redirect(to: "/invite/managers")}

        {:error, :not_found} ->
          {:noreply,
           socket
           |> put_flash(:error, "Invite code not found")
           |> push_redirect(to: "/invite/managers")}

          # TODO: Implement :already_added
          # {:error, :already_added} ->
          #   {:noreply, socket |> assign(:error, "Already added")}
      end
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Invite Managers")
  end
end
