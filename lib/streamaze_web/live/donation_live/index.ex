defmodule StreamazeWeb.DonationLive.Index do
  use StreamazeWeb, :live_view

  alias Streamaze.Finances
  alias Streamaze.Finances.Donation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :donations, list_donations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Donation")
    |> assign(:donation, Finances.get_donation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Donation")
    |> assign(:donation, %Donation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Donations")
    |> assign(:donation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    donation = Finances.get_donation!(id)
    {:ok, _} = Finances.delete_donation(donation)

    {:noreply, assign(socket, :donations, list_donations())}
  end

  defp list_donations do
    Finances.list_donations()
  end
end
