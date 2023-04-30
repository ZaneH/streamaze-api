defmodule Streamaze.Connectivity.Lanyard do
  alias Streamaze.Streams

  def update_value(streamer_id, key, value) do
    streamer = Streams.get_streamer!(streamer_id)
    discord_user_id = streamer.lanyard_config["discord_user_id"]
    api_key = streamer.lanyard_config["api_key"]

    case HTTPoison.put(
           "https://api.lanyard.rest/v1/users/#{discord_user_id}/kv/#{key}",
           to_string(value),
           %{
             "Authorization" => api_key
           }
         ) do
      {:ok, %{status_code: 204}} ->
        :ok

      {:ok, %{status_code: 404}} ->
        {:error, :not_found}

      {_, err} ->
        IO.inspect(err, label: "Lanyard Error")
        {:error, :unknown}
    end

    :ok
  end
end
