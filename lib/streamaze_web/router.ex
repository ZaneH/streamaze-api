defmodule StreamazeWeb.Router do
  use StreamazeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StreamazeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreamazeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/dashboard", DashboardController, :index

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
end
