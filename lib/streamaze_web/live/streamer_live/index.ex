# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.StreamerLive.Index do
  use StreamazeWeb, :live_view

  alias Streamaze.Streams
  alias Streamaze.Accounts.Streamer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :streamers, list_streamers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Streamer")
    |> assign(:streamer, Streams.get_streamer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Streamer")
    |> assign(:streamer, %Streamer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Streamers")
    |> assign(:streamer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    streamer = Streams.get_streamer!(id)
    {:ok, _} = Streams.delete_streamer(streamer)

    {:noreply, assign(socket, :streamers, list_streamers())}
  end

  defp list_streamers do
    Streams.list_streamers()
  end
end
