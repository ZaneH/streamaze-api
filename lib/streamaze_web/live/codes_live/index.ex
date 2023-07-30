defmodule StreamazeWeb.CodesLive.Index do
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    invite_code = Accounts.get_invite_code_for_user(current_user.id)

    {:ok,
     socket
     |> assign(:form, %{
       "my_invite_code" => invite_code
     })}
  end
end
