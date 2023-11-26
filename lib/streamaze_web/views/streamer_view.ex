# Copyright 2023, Zane Helton, All rights reserved.

defmodule StreamazeWeb.StreamerView do
  alias Streamaze.Accounts
  alias Streamaze.Streams
  use StreamazeWeb, :view

  def render("index.json", %{streamers: streamers}) do
    %{data: render_many(streamers, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("create.json", %{streamer: streamer}) do
    %{success: true, data: render_one(streamer, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("show.json", %{streamer: streamer}) do
    %{
      id: streamer.id,
      name: streamer.name,
      youtube_url: streamer.youtube_url
    }
  end

  def render("show_private.json", %{streamer: streamer}) do
    admin_accounts = get_admin_accounts(streamer)

    %{
      id: streamer.id,
      name: streamer.name,
      youtube_url: streamer.youtube_url,
      chat_config: streamer.chat_config,
      clip_config: streamer.clip_config,
      obs_config: streamer.obs_config,
      viewers_config: streamer.viewers_config,
      donations_config: streamer.donations_config,
      lanyard_config: streamer.lanyard_config,
      admin_config: %{
        streamers: admin_accounts,
        role: streamer.admin_config["role"],
        obs_key: streamer.admin_config["obs_key"]
      }
    }
  end

  def render("update.json", %{streamer: streamer}) do
    %{success: true, data: render_one(streamer, StreamazeWeb.StreamerView, "show.json")}
  end

  def render("error.json", %{error: error}) do
    %{success: false, error: error}
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      success: false,
      errors:
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
            opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
          end)
        end)
    }
  end

  defp get_admin_accounts(streamer) do
    try do
      if not is_nil(streamer.admin_config["streamer_ids"]) do
        streamer_ids = streamer.admin_config["streamer_ids"]

        for s <- streamer_ids ++ [streamer.id] do
          admin_owned_streamer = Streams.get_streamer!(s)
          api_key = Accounts.get_api_key_for_user(admin_owned_streamer.user_id)

          %{
            id: admin_owned_streamer.id,
            name: admin_owned_streamer.name,
            api_key: api_key
          }
        end
      else
        %{}
      end
    rescue
      _ ->
        IO.inspect("Error loading admin accounts for streamer #{streamer.id}")
        %{}
    end
  end
end
