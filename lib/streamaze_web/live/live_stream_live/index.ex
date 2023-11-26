# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.LiveStreamLive.Index do
  use StreamazeWeb, :live_view

  alias Streamaze.Streams
  alias Streamaze.Streams.LiveStream

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :live_streams, list_live_streams())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Live stream")
    |> assign(:live_stream, Streams.get_live_stream!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Live stream")
    |> assign(:live_stream, %LiveStream{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Live streams")
    |> assign(:live_stream, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    live_stream = Streams.get_live_stream!(id)
    {:ok, _} = Streams.delete_live_stream(live_stream)

    {:noreply, assign(socket, :live_streams, list_live_streams())}
  end

  defp list_live_streams do
    Streams.list_live_streams()
  end
end
