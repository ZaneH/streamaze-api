# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.SubscriptionView do
  use StreamazeWeb, :view

  def render("index.json", %{has_valid_subscription: hvs}) do
    %{has_valid_subscription: hvs}
  end
end
