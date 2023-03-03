defmodule StreamazeWeb.ExpenseView do
  use StreamazeWeb, :view

  def render("index.json", %{expense: expense}) do
    %{data: render_many(expense, StreamazeWeb.ExpenseView, "show.json")}
  end

  def render("create.json", %{expense: expense}) do
    %{success: true, data: render_one(expense, StreamazeWeb.ExpenseView, "show.json")}
  end

  def render("show.json", %{expense: expense}) do
    %{
      id: expense.id,
      amount: expense.amount,
      currency: expense.currency,
      streamer_id: expense.streamer_id,
      inserted_at: expense.inserted_at,
      updated_at: expense.updated_at
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      success: false,
      errors:
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)
    }
  end
end
