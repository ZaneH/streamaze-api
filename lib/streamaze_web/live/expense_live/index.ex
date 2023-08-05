defmodule StreamazeWeb.ExpenseLive.Index do
  alias Streamaze.Finances.Donation
  alias Streamaze.Streams
  use StreamazeWeb, :live_view
  on_mount(Streamaze.UserLiveAuth)

  alias Streamaze.Finances

  @impl true
  def mount(params, _session, socket) do
    streamer =
      if is_nil(params["streamer_id"]) do
        Streams.get_streamer_for_user(socket.assigns.current_user.id)
      else
        Streams.get_streamer!(params["streamer_id"])
      end

    %{entries: entries, metadata: metadata} =
      list_expenses(streamer.id, %{
        before: params["before"],
        after: params["after"]
      })

    {:ok,
     socket
     |> assign(:streamer, streamer)
     |> assign(:next, metadata.after)
     |> assign(:prev, metadata.before)
     |> assign(:total_count, metadata.total_count)
     |> assign(
       :expenses,
       entries
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Donation")
    |> assign(:donation, Finances.get_donation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Donation")
    |> assign(:donation, %Donation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Donations")
    |> assign(:donation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    donation = Finances.get_donation!(id)
    {:ok, _} = Finances.delete_donation(donation)

    {:noreply, assign(socket, :donations, list_expenses(socket.assigns.streamer.id))}
  end

  defp list_expenses(
         streamer_id,
         cursors \\ %{
           before: nil,
           after: nil
         }
       ) do
    cursors = %{
      before: replace_empty_string_with_nil(cursors.before),
      after: replace_empty_string_with_nil(cursors.after)
    }

    Finances.pagination_expenses(streamer_id, cursors)
  end
end
