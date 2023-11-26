# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.SubscriptionController do
  use StreamazeWeb, :controller

  alias Streamaze.Finances

  def index(conn, params) do
    user_id = Map.get(params, "user_id", nil)
    has_valid_subscription = Finances.has_valid_subscription?(user_id)

    render(conn, "index.json", has_valid_subscription: has_valid_subscription)
  end
end
