# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.Plugs.ValidSubscriptionPlug do
  import Plug.Conn
  alias Streamaze.Finances

  def init(_opts), do: %{}

  def call(conn, _opts) do
    current_user = Map.get(conn.assigns, "current_user", %{})
    user_id = Map.get(current_user, "id", nil)

    case Finances.has_valid_subscription?(user_id) do
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
