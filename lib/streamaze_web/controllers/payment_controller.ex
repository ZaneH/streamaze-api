# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.PaymentController do
  alias Streamaze.Finances
  use StreamazeWeb, :controller

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    is_subscribed = Finances.has_valid_subscription?(user_id)

    render(conn, "index.html",
      user_id: user_id,
      is_subscribed: is_subscribed,
      paypal_client_id: System.get_env("PAYPAL_CLIENT_ID"),
      paypal_plan_1_id: System.get_env("PAYPAL_PLAN_1_ID")
    )
  end

  defp create_checkout_session(conn, price_id, trial_period_days, metadata) do
    current_user = conn.assigns.current_user
    has_trialed = current_user.has_trialed

    session_data = %{
      mode: :subscription,
      line_items: [
        %{
          price: price_id,
          quantity: 1
        }
      ],
      metadata: metadata,
      success_url: StreamazeWeb.Router.Helpers.url(conn) <> "/account/upgrade",
      cancel_url: StreamazeWeb.Router.Helpers.url(conn) <> "/account/upgrade"
    }

    session_data =
      if has_trialed do
        session_data
      else
        Map.put(session_data, :subscription_data, %{
          trial_period_days: trial_period_days
        })
      end

    Stripe.Checkout.Session.create(session_data)
  end

  defp create_checkout_url(conn, :subscriber) do
    current_user = conn.assigns.current_user

    {:ok, session} =
      create_checkout_session(
        conn,
        "price_1NYk5LJZWxrZVRBH202hsxkA",
        10,
        %{
          "user_id" => current_user.id,
          "plan" => "subscriber"
        }
      )

    redirect(conn, external: session.url)
  end

  defp create_checkout_url(conn, :premium) do
    current_user = conn.assigns.current_user

    {:ok, session} =
      create_checkout_session(
        conn,
        "price_1Nam4jJZWxrZVRBHf7WYadab",
        10,
        %{
          "user_id" => current_user.id,
          "plan" => "premium"
        }
      )

    redirect(conn, external: session.url)
  end

  def subscriber(conn, _params) do
    create_checkout_url(conn, :subscriber)
  end

  def premium(conn, _params) do
    create_checkout_url(conn, :premium)
  end
end
