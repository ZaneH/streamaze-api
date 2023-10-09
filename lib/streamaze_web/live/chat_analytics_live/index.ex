defmodule StreamazeWeb.ChatAnalyticsLive.Index do
  alias Streamaze.Streams
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    chat_monitors = Streams.list_chat_monitors(current_user.streamer_id)

    xaxis_attrs =
      Enum.map(chat_monitors, fn cm ->
        Enum.map(cm.chat_activity, fn {k, _v} -> k end)
      end)

    yaxis_attrs =
      Enum.map(chat_monitors, fn cm ->
        Enum.map(cm.chat_activity, fn {_k, v} -> v end)
      end)

    {:ok,
     socket
     |> assign(:monitors, chat_monitors)
     |> assign(:xaxis, xaxis_attrs)
     |> assign(:yaxis, yaxis_attrs)}
  end
end
