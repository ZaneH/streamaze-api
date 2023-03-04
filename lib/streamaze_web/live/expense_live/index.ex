defmodule StreamazeWeb.ExpenseLive.Index do
  use StreamazeWeb, :live_view

  alias Streamaze.Finances
  alias Streamaze.Finances.Expense

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :expenses, list_expenses(params["streamer_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Finances.get_expense!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Finances.get_expense!(id)
    {:ok, _} = Finances.delete_expense(expense)

    streamer_id = expense.streamer_id
    {:noreply, assign(socket, :expenses, list_expenses(streamer_id))}
  end

  defp list_expenses(streamer_id) do
    Finances.list_streamer_expenses(streamer_id)
  end
end
