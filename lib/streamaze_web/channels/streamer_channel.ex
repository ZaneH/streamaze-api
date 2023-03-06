defmodule StreamazeWeb.StreamerChannel do
  use Phoenix.Channel

  # TODO: Implement authorization
  defp authorized?(_streamer_id) do
    true
  end

  def join("streamer:" <> streamer_id, _payload, socket) do
    if authorized?(streamer_id) == true do
      socket = assign(socket, :streamer_id, streamer_id)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
