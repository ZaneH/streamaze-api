# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.WidgetsLive.Index do
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  @url_prefix "http://localhost:3000"

  def mount(_params, _session, socket) do
    api_key = Accounts.get_api_key_for_user(socket.assigns.current_user.id)
    discord_id = Accounts.get_discord_id_for_user(socket.assigns.current_user.id)

    form = %{
      "subathon_clock_url" =>
        form_field_url("#{@url_prefix}/subathon/clock?isUser=true&streamazeKey=", "#{api_key}"),
      "chat_overlay_url" =>
        form_field_url("#{@url_prefix}/chat?isUser=true&streamazeKey=", "#{api_key}"),
      "ticker_url" =>
        form_field_url(
          "#{@url_prefix}/widget/ticker/#{discord_id}?isUser=true&streamazeKey=",
          "#{api_key}"
        ),
      "maze_url" =>
        form_field_url(
          "#{@url_prefix}/widget/maze/#{discord_id}?isUser=true&streamazeKey=",
          "#{api_key}"
        ),
      "all_subs_url" =>
        form_field_url(
          "#{@url_prefix}/widget/subs/all?isUser=true&streamazeKey=",
          "#{api_key}"
        ),
      "kick_subs_url" =>
        form_field_url(
          "#{@url_prefix}/widget/subs/kick?isUser=true&streamazeKey=",
          "#{api_key}"
        )
    }

    {:ok, socket |> assign(:form, form)}
  end

  defp form_field_url(base_url, api_key) do
    if String.length(api_key) > 0 do
      "#{base_url}#{api_key}"
    else
      "Not configured (Check your Lanyard settings)"
    end
  end
end
