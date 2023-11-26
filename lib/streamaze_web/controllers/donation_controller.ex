# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.DonationController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances
  alias Streamaze.Streams
  alias Streamaze.Connectivity

  def index(conn, _params) do
    donations = Finances.list_streamer_donations(conn.params["streamer_id"])
    render(conn, "index.json", donations: donations)
  end

  def create(conn, params) do
    case Finances.create_donation(params) do
      {:ok, donation} ->
        add_to_active_subathons(donation)
        broadcast_donation(donation)

        try do
          if not donation.exclude_from_profit do
            Connectivity.Lanyard.update_value(
              conn.params["streamer_id"],
              "net_profit",
              Streams.get_streamers_net_profit(conn.params["streamer_id"])
            )
          end

          streamer = Streams.get_streamer!(conn.params["streamer_id"])

          kick_gifted_offset =
            if streamer.stats_offset["kick_gifted_subscription"] do
              streamer.stats_offset["kick_gifted_subscription"]
            else
              0
            end

          kick_sub_offset =
            if streamer.stats_offset["kick_subscription"] do
              streamer.stats_offset["kick_subscription"]
            else
              0
            end

          youtube_offset =
            if streamer.stats_offset["subscription"] do
              streamer.stats_offset["subscription"]
            else
              0
            end

          Connectivity.Lanyard.update_value(
            conn.params["streamer_id"],
            "total_subs",
            Finances.get_all_sub_count(conn.params["streamer_id"]) + youtube_offset +
              kick_gifted_offset + kick_sub_offset
          )
        rescue
          _ in _ ->
            IO.puts(
              "Lanyard Error for donation: #{donation.id}. Perhaps the streamer_id: #{conn.params["streamer_id"]} is not configured for Lanyard."
            )
        end

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
          new_seconds =
            subathon.subathon_seconds_added +
              Decimal.to_float(donation.amount_in_usd) * subathon.subathon_minutes_per_dollar * 60

          Streams.update_live_stream(subathon, %{
            subathon_seconds_added: new_seconds
          })

          broadcast_subathon_update(subathon, new_seconds)
        end)

      _ ->
        :not_found
    end
  end

  defp broadcast_subathon_update(live_stream, seconds_added) do
    StreamazeWeb.Endpoint.broadcast("streamer:#{live_stream.streamer_id}", "subathon", %{
      id: live_stream.id,
      subathon_seconds_added: seconds_added,
      subathon_start_time: live_stream.subathon_start_time,
      subathon_start_minutes: live_stream.subathon_start_minutes,
      subathon_ended_time: live_stream.subathon_ended_time,
      subathon_minutes_per_dollar: live_stream.subathon_minutes_per_dollar
    })
  end

  defp broadcast_donation(donation) do
    StreamazeWeb.Endpoint.broadcast("streamer:#{donation.streamer_id}", "donation", %{
      net_profit: Streams.get_streamers_net_profit(donation.streamer_id),
      donation: %{
        id: donation.id,
        sender: donation.sender,
        type: donation.type,
        message: donation.message,
        displayString: Money.to_string(donation.value),
        metadata: donation.metadata,
        amount_in_usd: donation.amount_in_usd,
        value: %{
          amount: donation.value.amount,
          currency: donation.value.currency
        }
      }
    })

    StreamazeWeb.Endpoint.broadcast("streamer:#{donation.streamer_id}", "statistic", %{
      all_subs: Finances.get_all_sub_count(donation.streamer_id),
      kick_subs: Finances.get_kick_sub_count(donation.streamer_id),
      youtube_subs: Finances.get_youtube_sub_count(donation.streamer_id)
    })
  end
end
