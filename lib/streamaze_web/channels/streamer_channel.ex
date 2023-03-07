defmodule StreamazeWeb.StreamerChannel do
  use Phoenix.Channel

  alias Streamaze.Streams
  alias Streamaze.Finances

  # TODO: Implement authorization
  defp authorized?(_streamer_id) do
    true
  end

  def join("streamer:" <> streamer_id, _payload, socket) do
    if authorized?(streamer_id) == true do
      socket = assign(socket, :streamer_id, streamer_id)
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    streamer_id = socket.assigns.streamer_id
    active_stream = Streams.get_live_stream_by_streamer_id(streamer_id)
    latest_donations = Finances.list_streamer_donations(streamer_id)
    latest_expenses = Finances.list_streamer_expenses(streamer_id)

    push(socket, "initial_state", %{
      net_profit: Streams.get_streamers_net_profit(streamer_id),
      active_stream: %{
        donation_goal: active_stream.donation_goal,
        donation_goal_currency: active_stream.donation_goal_currency,
        is_live: active_stream.is_live,
        is_subathon: active_stream.is_subathon,
        subathon_minutes_per_dollar: active_stream.subathon_minutes_per_dollar,
        subathon_seconds_added: active_stream.subathon_seconds_added,
        subathon_start_minutes: active_stream.subathon_start_minutes,
        subathon_start_time: active_stream.subathon_start_time,
        subathon_ended_time: active_stream.subathon_ended_time
      },
      last_10_donations:
        Enum.map(latest_donations, fn donation ->
          %{
            value: %{
              amount: donation.value.amount,
              currency: donation.value.currency
            },
            message: donation.message,
            name: donation.sender,
            streamer_id: donation.streamer_id,
            inserted_at: donation.inserted_at
          }
        end),
      last_10_expenses:
        Enum.map(latest_expenses, fn expense ->
          %{
            value: %{
              amount: expense.value.amount,
              currency: expense.value.currency
            },
            streamer_id: expense.streamer_id,
            inserted_at: expense.inserted_at
          }
        end)
    })

    {:noreply, socket}
  end
end
