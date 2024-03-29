# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.DashboardLive.Index do
  alias Streamaze.Streams
  alias Streamaze.Finances
  alias Streamaze.Accounts
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  def mount(%{"streamer_id" => ""}, _session, socket) do
    {:ok, redirect(socket, to: Routes.dashboard_index_path(socket, :index))}
  end

  @impl true
  def mount(%{"streamer_id" => streamer_id}, _session, socket) do
    form = %{"selected_streamer_id" => streamer_id}

    selected_streamer = Streams.get_streamer!(streamer_id)
    active_streams = Streams.list_active_live_streams(selected_streamer.id)
    inactive_streams = Streams.list_inactive_live_streams(selected_streamer.id)
    expenses = Finances.list_streamer_expenses(selected_streamer.id)
    donations = Finances.list_streamer_donations(selected_streamer.id)
    managed_streamers = Accounts.list_streamers_for_manager(socket.assigns.current_user.id)
    {:ok, net_profit} = Money.parse(Streams.get_streamers_net_profit(selected_streamer.id), :USD)

    {:ok, total_donations} =
      Money.parse(Finances.get_streamers_total_donations(selected_streamer.id) || 0.0)

    {:ok, total_expenses} =
      Money.parse(Finances.get_streamers_total_expenses(selected_streamer.id) || 0.0)

    {:ok,
     assign(socket, :selected_streamer, selected_streamer)
     |> assign(:live_streams, active_streams)
     |> assign(:streamer_expenses, expenses)
     |> assign(:latest_donations, donations)
     |> assign(:latest_inactive_streams, inactive_streams)
     |> assign(:selected_streamer_id, selected_streamer.id)
     |> assign(:managed_streamers, managed_streamers)
     |> assign(:net_profit, net_profit)
     |> assign(:form, form)
     |> assign(:total_donations, total_donations)
     |> assign(:total_expenses, total_expenses)}
  end

  def mount(_params, _session, socket) do
    form = %{"selected_streamer_id" => nil}

    managed_streamers = Accounts.list_streamers_for_manager(socket.assigns.current_user.id)

    {:ok,
     assign(socket, :selected_streamer, nil)
     |> assign(:managed_streamers, managed_streamers)
     |> assign(:selected_streamer_id, nil)
     |> assign(:form, form)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event(
        "update_selected_streamer",
        %{"selected_streamer_id" => selected_streamer_id},
        socket
      ) do
    {:noreply,
     redirect(socket,
       to: Routes.dashboard_index_path(socket, :index, streamer_id: selected_streamer_id)
     )}
  end

  @impl true
  def handle_event(
        "view_all_donations",
        _params,
        socket
      ) do
    {:noreply,
     redirect(socket,
       to:
         Routes.dashboard_donations_path(socket, :index,
           streamer_id: socket.assigns.selected_streamer_id
         )
     )}
  end

  @impl true
  def handle_event(
        "view_all_expenses",
        _params,
        socket
      ) do
    {:noreply,
     redirect(socket,
       to:
         Routes.dashboard_expenses_path(socket, :index,
           streamer_id: socket.assigns.selected_streamer_id
         )
     )}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Dashboard")
  end
end
