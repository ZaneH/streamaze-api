defmodule StreamazeWeb.ExpenseController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances
  alias Streamaze.Streams
  alias Streamaze.Connectivity

  def index(conn, _params) do
    expenses = Finances.list_streamer_expenses(conn.params["streamer_id"])
    render(conn, "index.json", expense: expenses)
  end

  def create(conn, params) do
    case Finances.create_expense(params) do
      {:ok, expense} ->
        broadcast_expense(expense)

        try do
          Connectivity.Lanyard.update_value(
            conn.params["streamer_id"],
            "net_profit",
            Streams.get_streamers_net_profit(conn.params["streamer_id"])
          )
        rescue
          _ in _ ->
            IO.puts(
              "Lanyard Error for expense: #{expense.id}. Perhaps the streamer_id: #{conn.params["streamer_id"]} is not configured for Lanyard."
            )
        end

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
      net_profit: Streams.get_streamers_net_profit(expense.streamer_id),
      expense: %{
        streamer_id: expense.streamer_id,
        value: %{
          amount: expense.value.amount,
          currency: expense.value.currency
        }
      }
    })
  end
end
