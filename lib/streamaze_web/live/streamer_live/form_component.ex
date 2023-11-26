# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.StreamerLive.FormComponent do
  use StreamazeWeb, :live_component

  alias Streamaze.Streams

  @impl true
  def update(%{streamer: streamer} = assigns, socket) do
    changeset = Streams.change_streamer(streamer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"streamer" => streamer_params}, socket) do
    changeset =
      socket.assigns.streamer
      |> Streams.change_streamer(streamer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"streamer" => streamer_params}, socket) do
    save_streamer(socket, socket.assigns.action, streamer_params)
  end

  defp save_streamer(socket, :edit, streamer_params) do
    case Streams.update_streamer(socket.assigns.streamer, streamer_params) do
      {:ok, _streamer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Streamer updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_streamer(socket, :new, streamer_params) do
    case Streams.create_streamer(streamer_params) do
      {:ok, _streamer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Streamer created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
