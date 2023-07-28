defmodule StreamazeWeb.PaymentController do
  use StreamazeWeb, :controller

  def index(conn, _params) do
    {:ok, setup_intent} =
      Stripe.SetupIntent.create(%{automatic_payment_methods: %{enabled: true}})

    render(conn, "index.html", setup_intent: setup_intent)
  end

  def subscriber(conn, _params) do
    current_user = conn.assigns.current_user

    {:ok, session} =
      Stripe.Checkout.Session.create(%{
        mode: :subscription,
        line_items: [
          %{
            price: "price_1NYk5LJZWxrZVRBH202hsxkA",
            quantity: 1
          }
        ],
        subscription_data: %{
          trial_period_days: 10
        },
        metadata: %{
          "user_id" => current_user.id,
          "plan" => "subscriber"
        },
        success_url: StreamazeWeb.Router.Helpers.url(conn) <> "/payment",
        cancel_url: StreamazeWeb.Router.Helpers.url(conn) <> "/payment"
      })

    redirect(conn, external: session.url)
  end
end
