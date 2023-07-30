defmodule StreamazeWeb.WidgetsLive.Index do
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount Streamaze.UserLiveAuth

  def mount(_params, _session, socket) do
    api_key = Accounts.get_api_key_for_user(socket.assigns.current_user.id)
    discord_id = Accounts.get_discord_id_for_user(socket.assigns.current_user.id)

    form = %{
      "subathon_clock_url" => "https://streamaze.live/subathon/clock?api_key=#{api_key}",
      "chat_overlay_url" => "https://streamaze.live/chat?api_key=#{api_key}",
      "ticker_url" => "https://streamaze.live/widget/ticker/#{discord_id}"
    }

    {:ok, socket |> assign(:form, form)}
  end
end
