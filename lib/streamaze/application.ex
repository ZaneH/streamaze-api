# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Streamaze.Repo,
      # Start the Telemetry supervisor
      StreamazeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Streamaze.PubSub},
      # Start the Endpoint (http/https)
      StreamazeWeb.Endpoint,
      # Start a worker by calling: Streamaze.Worker.start_link(arg)
      # {Streamaze.Worker, arg}
      {ChannelWatcher, :streamer},
      {Cachex, name: :subscription_cache, expiration: {:expiration, 3600 * 60, 50, true}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Streamaze.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamazeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
