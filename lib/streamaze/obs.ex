# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.OBS do
  def switch_scene(streamer_key, scene) do
    case HTTPoison.put(create_request_url("/streamers/#{streamer_key}/scene/#{scene}")) do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def start_server(streamer_key, %{"service" => service}) do
    qs = service_to_url_params(String.downcase(service))
    start_url = create_request_url("/streamers/#{streamer_key}/server/start?#{qs}")

    case HTTPoison.post(start_url, "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def switch_profile(streamer_key, %{"profile" => profile}) do
    switch_url = create_request_url("/streamers/#{streamer_key}/profiles")

    case HTTPoison.patch(
           switch_url,
           Jason.encode!(%{
             currentProfileName: profile
           }),
           [{"Content-Type", "application/json"}]
         ) do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def stop_server(streamer_key) do
    stop_url = create_request_url("/streamers/#{streamer_key}/server/stop")

    case HTTPoison.post(stop_url, "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def start_broadcast(streamer_key) do
    start_url = create_request_url("/streamers/#{streamer_key}/stream/start")

    case HTTPoison.post(start_url, "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def stop_broadcast(streamer_key) do
    stop_url = create_request_url("/streamers/#{streamer_key}/stream/stop")

    case HTTPoison.post(stop_url, "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  def stop_pi(streamer_key) do
    stop_url = create_request_url("/streamers/#{streamer_key}/device/shutdown")

    case HTTPoison.post(stop_url, "") do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok

      e ->
        IO.inspect(e)
        {:error, "Bad response code"}
    end
  end

  defp service_to_url_params("youtube") do
    "id=default"
  end

  defp service_to_url_params("tiktok") do
    "id=tiktok"
  end

  defp create_request_url(path) do
    get_secret_url() <> path
  end

  defp get_secret_url do
    Application.get_all_env(:streamaze)[Streamaze.OBS][:livebond_api_url]
  end
end
