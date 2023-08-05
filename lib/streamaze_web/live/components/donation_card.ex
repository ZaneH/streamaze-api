defmodule DonationCard do
  import StreamazeWeb.LiveHelpers
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <li class="py-3 sm:py-4">
        <div class="flex items-center space-x-4">
            <div class="flex-shrink-0 relative inline-flex items-center justify-center w-8 h-8 overflow-hidden bg-gray-100 rounded-full dark:bg-gray-600">
                <%= if @donation.metadata["pfp"] do %>
                    <img class="w-8 h-8 rounded-full" src={@donation.metadata["pfp"]} alt="Rounded avatar">
                <% else %>
                    <span class="font-medium text-gray-600 dark:text-gray-300"><%= String.at(@donation.sender, 0) %></span>
                <% end %>
            </div>
            <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate dark:text-white">
                    <%= @donation.sender %>
                </p>
                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                    <%= donation_type_to_string(@donation.type) %>
                </p>
            </div>
            <%= if not Money.zero?(@donation.value) do %>
                <div class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white">
                    <%= Money.to_string(@donation.value) %>
                </div>
            <% end %>
        </div>
        <%= if @donation.message do %>
            <div class="mt-3 text-gray-700 dark:text-gray-200 break-all"><%= @donation.message %></div>
        <% end %>
        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">
            <time phx-hook="LocalTime" id="my-local-time"><%= @donation.inserted_at %></time>
        </p>
    </li>
    """
  end
end
