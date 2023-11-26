# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.UserRegistrationController do
  alias Streamaze.Streams
  use StreamazeWeb, :controller

  alias Streamaze.Accounts
  alias Streamaze.Accounts.User
  alias StreamazeWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # case Accounts.register_user(user_params) do
    #   {:ok, user} ->
    #     {:ok, _} =
    #       Accounts.deliver_user_confirmation_instructions(
    #         user,
    #         &Routes.user_confirmation_url(conn, :edit, &1)
    #       )

    #     {:ok, streamer} =
    #       Streams.create_streamer(%{
    #         user_id: user.id
    #       })

    #     {:ok, _} =
    #       Streams.create_live_stream(%{
    #         streamer_id: streamer.id,
    #         is_live: true,
    #         is_subathon: false
    #       })

    #     Accounts.update_user!(user.id, %{streamer_id: streamer.id})

    #     conn
    #     |> put_flash(:info, "User created successfully.")
    #     |> UserAuth.log_in_user(user)

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end

    conn
    |> put_flash(:error, "User registration is currently disabled.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
