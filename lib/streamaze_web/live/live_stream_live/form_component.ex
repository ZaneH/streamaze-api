# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.LiveStreamLive.FormComponent do
  use StreamazeWeb, :live_component

  alias Streamaze.Streams

  @impl true
  def update(%{live_stream: live_stream} = assigns, socket) do
    changeset = Streams.change_live_stream(live_stream)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"live_stream" => live_stream_params}, socket) do
    changeset =
      socket.assigns.live_stream
      |> Streams.change_live_stream(live_stream_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"live_stream" => live_stream_params}, socket) do
    save_live_stream(socket, socket.assigns.action, live_stream_params)
  end

  defp save_live_stream(socket, :edit, live_stream_params) do
    case Streams.update_live_stream(socket.assigns.live_stream, live_stream_params) do
      {:ok, _live_stream} ->
        {:noreply,
         socket
         |> put_flash(:info, "Live stream updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_live_stream(socket, :new, live_stream_params) do
    case Streams.create_live_stream(live_stream_params) do
      {:ok, _live_stream} ->
        {:noreply,
         socket
         |> put_flash(:info, "Live stream created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
