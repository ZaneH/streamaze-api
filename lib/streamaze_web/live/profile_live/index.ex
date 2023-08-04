defmodule StreamazeWeb.ProfileLive.Index do
  alias Streamaze.Streams
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  def mount(_params, _session, socket) do
    streamer = Streams.get_streamer_for_user(socket.assigns.current_user.id)

    {:ok,
     socket
     |> assign(
       streamer: streamer,
       profile: %{
         "name" => streamer.name,
         "youtube_url" => streamer.youtube_url
       },
       dashboard_config: %{
         chat_config: streamer.chat_config,
         clip_config: streamer.clip_config,
         viewers_config: streamer.viewers_config,
         donations_config: censor_config(streamer.donations_config),
         lanyard_config: censor_config(streamer.lanyard_config)
       }
     )}
  end

  defp censor_config(config) do
    if not is_nil(config) do
      Map.update(config, "streamlabs_token", nil, &(String.slice(&1, 0..11) <> "..."))
      |> Map.update("elevenlabs_key", nil, &(String.slice(&1, 0..4) <> "..."))
      # lanyard
      |> Map.update("api_key", nil, &(String.slice(&1, 0..4) <> "..."))
    else
      %{}
    end
  end

  def handle_event("save", params, socket) do
    streamer = Streams.get_streamer_for_user(socket.assigns.current_user.id)

    case Streams.update_streamer(streamer, params) do
      {:ok, _streamer} ->
        {:noreply, socket |> assign(:profile, params)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
