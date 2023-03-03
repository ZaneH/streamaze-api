defmodule StreamazeWeb.ExpenseController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances

  def index(conn, _params) do
    expenses = Finances.list_expenses()
    render(conn, "index.json", expense: expenses)
  end

  def create(conn, params) do
    case Finances.create_expense(params) do
      {:ok, expense} ->
        conn
        |> put_status(:created)
        |> render("create.json", expense: expense)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
