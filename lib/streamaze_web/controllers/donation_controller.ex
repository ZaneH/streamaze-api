defmodule StreamazeWeb.DonationController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances

  def index(conn, _params) do
    donations = Finances.list_donations()
    render(conn, "index.json", donations: donations)
  end

  def create(conn, params) do
    case Finances.create_donation(params) do
      {:ok, donation} ->
        conn
        |> put_status(:created)
        |> render("create.json", donation: donation)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
