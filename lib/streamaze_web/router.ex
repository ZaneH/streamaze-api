# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.Router do
  use StreamazeWeb, :router

  import StreamazeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StreamazeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :subscription_api do
    plug :accepts, ["json"]
    plug StreamazeWeb.Plugs.ValidSubscriptionPlug
  end

  pipeline :no_subscription_api do
    plug :accepts, ["json"]
  end

  scope "/", StreamazeWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/overview", DashboardLive.Index, :index
    live "/dashboard/donations", DashboardLive.Donations, :index
    live "/dashboard/expenses", DashboardLive.Expenses, :index

    live "/widgets", WidgetsLive.Index, :index

    live "/invite/managers", ManagersLive.Index, :index
    live "/invite/codes", CodesLive.Index, :index

    live "/streamers", StreamerLive.Index, :index
    live "/streamers/new", StreamerLive.Index, :new
    live "/streamers/:id/edit", StreamerLive.Index, :edit

    live "/streamers/:id", StreamerLive.Show, :show
    live "/streamers/:id/show/edit", StreamerLive.Show, :edit

    live "/live_streams", LiveStreamLive.Index, :index
    live "/live_streams/new", LiveStreamLive.Index, :new
    live "/live_streams/:id/edit", LiveStreamLive.Index, :edit

    live "/live_streams/:id", LiveStreamLive.Show, :show
    live "/live_streams/:id/show/edit", LiveStreamLive.Show, :edit

    live "/expenses", ExpenseLive.Index, :index
    live "/expenses/new", ExpenseLive.Index, :new
    live "/expenses/:id/edit", ExpenseLive.Index, :edit

    live "/expenses/:id", ExpenseLive.Show, :show
    live "/expenses/:id/show/edit", ExpenseLive.Show, :edit

    live "/donations", DonationLive.Index, :index
    live "/donations/new", DonationLive.Index, :new
    live "/donations/:id/edit", DonationLive.Index, :edit

    live "/donations/:id", DonationLive.Show, :show
    live "/donations/:id/show/edit", DonationLive.Show, :edit

    live "/analytics/chat", ChatAnalyticsLive.Index, :index
  end

  scope "/", StreamazeWeb do
    pipe_through [:api]

    post "/stripe/webhook", StripeWebhookController, :index
    post "/payment/paypal/webhook", PaypalWebhookController, :index
    post "/payment/paypal/subscription", PaypalController, :subscription
  end

  scope "/", StreamazeWeb do
    # Non-subscribed routes
    pipe_through [:no_subscription_api]

    get "/api/streamers/current", StreamerController, :current
    get "/api/live_streams/current", LiveStreamController, :current

    resources "/api/donations", DonationController, only: [:index]
    resources "/api/expenses", ExpenseController, only: [:index]
    resources "/api/streamers", StreamerController, only: [:index, :create, :update]
    # index lists available voices
    resources "/api/tts", TTSController, only: [:index]
    resources "/api/giveaway_entries", GiveawayEntryController, only: [:index]
    
    # Premium routes
    resources "/api/tts", TTSController, only: [:create]
    resources "/api/donations", DonationController, only: [:create]
    resources "/api/expenses", ExpenseController, only: [:create]
    resources "/api/live_streams", LiveStreamController, only: [:index, :create, :update, :show]
    resources "/api/chat-monitor", ChatMonitorController, only: [:index, :create, :update, :show]

    resources "/api/giveaway_entries", GiveawayEntryController, only: [:create, :update]

    post "/api/giveaway_entries/reset", GiveawayEntryController, :reset

    get "/api/giveaway_entry/:entry_username/:chat_username",
        GiveawayEntryController,
        :assign_chat_name

    post "/api/upload/:type", UploadController, :upload
  end

  scope "/", StreamazeWeb do
    pipe_through [:subscription_api]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser

  #     live_dashboard "/dashboard", metrics: StreamazeWeb.Telemetry
  #   end
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", StreamazeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/account/register", UserRegistrationController, :new
    post "/account/register", UserRegistrationController, :create
    get "/account/login", UserSessionController, :new
    post "/account/login", UserSessionController, :create
    get "/account/reset_password", UserResetPasswordController, :new
    post "/account/reset_password", UserResetPasswordController, :create
    get "/account/reset_password/:token", UserResetPasswordController, :edit
    put "/account/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", StreamazeWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/account/upgrade", PaymentController, :index
    get "/payment/stripe/subscriber", PaymentController, :subscriber
    get "/payment/stripe/premium", PaymentController, :premium

    live "/account/profile", ProfileLive.Index, :index
    get "/account/settings", UserSettingsController, :edit
    put "/account/settings", UserSettingsController, :update
    get "/account/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", StreamazeWeb do
    pipe_through [:browser]

    delete "/account/log_out", UserSessionController, :delete
    get "/account/confirm", UserConfirmationController, :new
    post "/account/confirm", UserConfirmationController, :create
    get "/account/confirm/:token", UserConfirmationController, :edit
    post "/account/confirm/:token", UserConfirmationController, :update
  end
end
