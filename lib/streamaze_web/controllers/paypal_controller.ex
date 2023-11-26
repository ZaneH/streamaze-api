# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.PaypalController do
  alias Streamaze.Payments
  use StreamazeWeb, :controller

  def subscription(conn, params) do
    subscription_id = params["subscriptionId"]
    user_id = params["userId"]
    item_id = params["itemId"]

    case Payments.create_pending_paypal_subscription(%{
           subscription_id: subscription_id,
           user_id: user_id,
           item_id: Kernel.inspect(item_id)
         }) do
      {:ok, _} ->
        send_resp(conn, 200, "OK")

      {:error, _} ->
        send_resp(conn, 500, "Error")
    end

    send_resp(conn, 200, "OK")
  end
end
