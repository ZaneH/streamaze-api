# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.Plugs.ValidSubscriptionPlug do
  import Plug.Conn
  alias Streamaze.Finances

  def init(_opts), do: %{}

  def call(conn, _opts) do
    current_user = Map.get(conn.assigns, "current_user", %{})
    user_id = Map.get(current_user, "id", nil)

    case get_subscription_status(user_id) do
      {:ok, true} ->
        assign(conn, :subscription_status, true)

      _ ->
        # Handle cache error, fallback to rechecking the subscription
        case check_subscription(user_id) do
          true ->
            assign(conn, :subscription_status, :valid)

          _ ->
            conn
            |> assign(:subscription_status, :invalid)
            |> Plug.Conn.send_resp(401, [])
            |> Plug.Conn.halt()
        end
    end
  end

  defp get_subscription_status(user_id) do
    Cachex.get(:subscription_cache, Kernel.to_string(user_id))
  end

  defp store_subscription_status(user_id, status) do
    Cachex.put(:subscription_cache, Kernel.to_string(user_id), status)
  end

  defp check_subscription(user_id) do
    result = Finances.has_valid_subscription?(user_id)

    # Store the result in the cache
    store_subscription_status(user_id, result)

    result
  end
end
