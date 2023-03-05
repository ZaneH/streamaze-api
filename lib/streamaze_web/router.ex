defmodule StreamazeWeb.Router do
  use StreamazeWeb, :router

  alias StreamazeWeb.{
    StreamerController,
    DonationController,
    ExpenseController,
    LiveStreamController
  }

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

    resources "/api/streamers", StreamerController, only: [:index, :create]
    resources "/api/donations", DonationController, only: [:index, :create]
    resources "/api/expenses", ExpenseController, only: [:index, :create]
    resources "/api/live_streams", LiveStreamController, only: [:index, :create, :update]
  end

  scope "/", StreamazeWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/dashboard", DashboardLive.Index, :index
    live "/managers/invite", ManagersLive.Index, :index

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
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamazeWeb do
  #   pipe_through :api
  # end

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

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", StreamazeWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", StreamazeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
