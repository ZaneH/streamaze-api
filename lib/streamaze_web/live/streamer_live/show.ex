# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.StreamerLive.Show do
  use StreamazeWeb, :live_view

  alias Streamaze.Streams

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:streamer, Streams.get_streamer!(id))}
  end

  defp page_title(:show), do: "Show Streamer"
  defp page_title(:edit), do: "Edit Streamer"
end
