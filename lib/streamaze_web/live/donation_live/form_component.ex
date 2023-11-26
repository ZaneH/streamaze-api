# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.DonationLive.FormComponent do
  use StreamazeWeb, :live_component

  alias Streamaze.Finances

  @impl true
  def update(%{donation: donation} = assigns, socket) do
    changeset = Finances.change_donation(donation)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"donation" => donation_params}, socket) do
    changeset =
      socket.assigns.donation
      |> Finances.change_donation(donation_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"donation" => donation_params}, socket) do
    save_donation(socket, socket.assigns.action, donation_params)
  end

  defp save_donation(socket, :edit, donation_params) do
    case Finances.update_donation(socket.assigns.donation, donation_params) do
      {:ok, _donation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Donation updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_donation(socket, :new, donation_params) do
    case Finances.create_donation(donation_params) do
      {:ok, _donation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Donation created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
