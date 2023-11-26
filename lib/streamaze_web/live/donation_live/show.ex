# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.DonationLive.Show do
  use StreamazeWeb, :live_view

  alias Streamaze.Finances

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:donation, Finances.get_donation!(id))}
  end

  defp page_title(:show), do: "Show Donation"
  defp page_title(:edit), do: "Edit Donation"
end
