defmodule ExpenseCard do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <li class="py-3 sm:py-4">
        <div class="flex items-center space-x-4">
            <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900 truncate dark:text-white">
                    <%= Money.to_string(@expense.value, code: true) %>
                </p>
                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                    <time phx-hook="LocalTime" id="my-local-time"><%= @expense.inserted_at %></time>
                </p>
            </div>
        </div>
    </li>
    """
  end
end
