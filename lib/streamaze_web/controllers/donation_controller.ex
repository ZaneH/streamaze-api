defmodule StreamazeWeb.DonationController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances
  alias Streamaze.Streams

  def index(conn, _params) do
    donations = Finances.list_donations()
    render(conn, "index.json", donations: donations)
  end

  def create(conn, params) do
    case Finances.create_donation(params) do
      {:ok, donation} ->
        add_to_active_subathons(donation)

        conn
        |> put_status(:created)
        |> render("create.json", donation: donation)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  defp add_to_active_subathons(donation) do
    case Streams.list_active_subathons(donation.streamer_id) do
      subathons when is_list(subathons) and length(subathons) > 0 ->
        subathons
        |> Enum.map(fn subathon ->
          Streams.update_live_stream(subathon, %{
            subathon_seconds_added:
              subathon.subathon_seconds_added +
                donation.amount * subathon.subathon_minutes_per_dollar * 60
          })
        end)

      _ ->
        {:error, "No active subathon found"}
    end
  end
end
