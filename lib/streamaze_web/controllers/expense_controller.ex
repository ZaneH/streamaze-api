defmodule StreamazeWeb.ExpenseController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances

  def index(conn, _params) do
    expenses = Finances.list_streamer_expenses(conn.params["streamer_id"])
    render(conn, "index.json", expense: expenses)
  end

  def create(conn, params) do
    case Finances.create_expense(params) do
      {:ok, expense} ->
        broadcast_expense(expense)

        conn
        |> put_status(:created)
        |> render("create.json", expense: expense)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  defp broadcast_expense(expense) do
    StreamazeWeb.Endpoint.broadcast("streamer:#{expense.streamer_id}", "expense", %{
      streamer_id: expense.streamer_id,
      value: %{
        amount: expense.value.amount,
        currency: expense.value.currency
      }
    })
  end
end
