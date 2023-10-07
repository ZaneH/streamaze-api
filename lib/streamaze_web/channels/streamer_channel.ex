defmodule StreamazeWeb.StreamerChannel do
  require Logger
  use Phoenix.Channel

  alias StreamazeWeb.AlertAudioController
  alias Streamaze.Accounts
  alias Streamaze.OBS
  alias Streamaze.Streams
  alias Streamaze.Finances

  # alias Streamaze.Connectivity.Viewers

  defp authorized?(streamer_id, given_token) do
    found_user = Accounts.get_user_by_api_key(streamer_id, given_token)

    case found_user do
      %Accounts.User{} ->
        true

      _ ->
        false
    end
  end

  # def start_viewer_agent(viewers_config) do
  #   Viewers.start_link(%{
  #     "kick_channel_name" => viewers_config["kick_channel_name"]
  #   })
  # end

  def join("streamer:" <> streamer_id, payload, socket) do
    if authorized?(streamer_id, payload["userToken"]) do
      send(self(), :after_join)

      {:ok, socket |> assign(:streamer_id, streamer_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("maze:" <> streamer_id, payload, socket) do
    if authorized?(streamer_id, payload["userToken"]) do
      send(self(), :after_join_maze)

      {:ok,
       socket
       |> assign(:streamer_id, streamer_id)
       |> assign(:maze_state, %{
         "cursor_idx" => 0
       })}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in(
        "update_cursor",
        %{"cursor_idx" => cursor_idx},
        socket
      ) do
    streamer_id = socket.assigns.streamer_id
    maze_state = socket.assigns.maze_state
    Map.put(maze_state, "cursor_idx", cursor_idx)

    StreamazeWeb.Endpoint.broadcast("maze:#{streamer_id}", "cursor", %{
      "cursor_idx" => cursor_idx
    })

    {:noreply, socket |> assign(:maze_state, maze_state)}
  end

  def handle_in(
        "switch_scene",
        %{
          "obs_key" => obs_key,
          "scene" => scene
        } = payload,
        socket
      ) do
    case OBS.switch_scene(obs_key, scene) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error switching to #{scene}")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in(
        "start_server",
        %{
          "obs_key" => obs_key,
          "service" => service
        } = payload,
        socket
      ) do
    case OBS.start_server(obs_key, %{"service" => service}) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error starting #{service} server")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in(
        "switch_profile",
        %{
          "obs_key" => obs_key,
          "profile" => profile
        } = payload,
        socket
      ) do
    case OBS.switch_profile(obs_key, %{"profile" => profile}) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error switching to #{profile} profile")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in("stop_server", %{"obs_key" => obs_key} = payload, socket) do
    case OBS.stop_server(obs_key) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error stopping server")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in("start_broadcast", %{"obs_key" => obs_key} = payload, socket) do
    case OBS.start_broadcast(obs_key) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error starting broadcast")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in("stop_broadcast", %{"obs_key" => obs_key} = payload, socket) do
    case OBS.stop_broadcast(obs_key) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error stopping broadcast")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in("stop_pi", %{"obs_key" => obs_key} = payload, socket) do
    case OBS.stop_pi(obs_key) do
      :ok ->
        {:reply, {:ok, payload}, socket}

      {:error, _} ->
        payload = Map.put(payload, "reason", "Error stopping Pi")
        {:reply, {:error, payload}, socket}
    end
  end

  def handle_in("update_subathon_settings", payload, socket) do
    live_stream = Streams.get_live_stream_by_streamer_id(socket.assigns.streamer_id)

    case Streams.update_live_stream(live_stream, payload) do
      {:ok, _} ->
        {:reply, {:ok, payload}, socket}

      {:error, %Ecto.Changeset{} = _} ->
        payload = Map.put(payload, "reason", "Error updating subathon settings")
        {:reply, {:error, payload}, socket}
    end
  end

  # def handle_in("fetch_viewer_count", payload, socket) do
  #   viewers_pid = socket.assigns.viewers_pid

  #   case Viewers.fetch_kick_viewer_count(viewers_pid) do
  #     nil ->
  #       payload = Map.put(payload, "reason", "Error fetching viewer count")
  #       {:reply, {:error, payload}, socket}

  #     viewer_count ->
  #       {:reply, {:ok, %{kick_viewer_count: viewer_count}}, socket}
  #   end
  # end

  def handle_info(:after_join, socket) do
    streamer_id = socket.assigns.streamer_id
    active_stream = Streams.get_live_stream_by_streamer_id(streamer_id)
    latest_donations = Finances.list_streamer_donations(streamer_id)
    streamer = Streams.get_streamer!(streamer_id)
    # viewers_pid = start_viewer_agent(streamer.viewers_config)
    donation_alert_url =
      AlertAudioController.get_signed_alert_audio_url(streamer.donation_audio_s3)

    # :ok =
    #   ChannelWatcher.monitor(:streamer, self(), {
    #     __MODULE__,
    #     :leave,
    #     [streamer_id]
    #   })

    if active_stream do
      push(socket, "initial_state", %{
        net_profit: Streams.get_streamers_net_profit(streamer_id),
        donation_alert_url: donation_alert_url,
        active_stream: %{
          id: active_stream.id,
          streamer_id: active_stream.streamer_id,
          donation_goal: active_stream.donation_goal,
          donation_goal_currency: active_stream.donation_goal_currency,
          start_time: active_stream.start_time,
          is_live: active_stream.is_live,
          is_subathon: active_stream.is_subathon,
          subathon_minutes_per_dollar: active_stream.subathon_minutes_per_dollar,
          subathon_seconds_added: active_stream.subathon_seconds_added,
          subathon_start_minutes: active_stream.subathon_start_minutes,
          subathon_start_time: active_stream.subathon_start_time,
          subathon_ended_time: active_stream.subathon_ended_time
        },
        stats: %{
          all_subs: Finances.get_all_sub_count(streamer_id),
          kick_subs: Finances.get_kick_sub_count(streamer_id),
          youtube_subs: Finances.get_youtube_sub_count(streamer_id)
        },
        stats_offset: streamer.stats_offset,
        last_10_donations:
          Enum.map(latest_donations, fn donation ->
            %{
              type: donation.type,
              display_string: Money.to_string(donation.value),
              message: donation.message,
              sender: donation.sender,
              streamer_id: donation.streamer_id,
              inserted_at: donation.inserted_at,
              amount_in_usd: donation.amount_in_usd,
              metadata: donation.metadata,
              value: %{
                amount: donation.value.amount,
                currency: donation.value.currency
              }
            }
          end)
      })
    end

    {
      :noreply,
      socket
      # |> assign(viewers_pid: viewers_pid)
    }
  end

  def handle_info(:after_join_maze, socket) do
    push(socket, "initial_state_maze", %{})

    {
      :noreply,
      socket
    }
  end

  def leave(streamer_id) do
    # :ok = ChannelWatcher.demonitor(:streamer, self())

    Logger.info("Streamer #{streamer_id} disconnected")
  end
end
