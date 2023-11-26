# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.UserLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias Streamaze.Accounts
  alias StreamazeWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)

    # TODO: Use confirmed_at to determine if user is confirmed
    # if socket.assigns.current_user.confirmed_at do
    {:cont, socket}
    # else
    # {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
    # end
  end

  def on_mount(:default, _params, _session, socket) do
    {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
  end
end
