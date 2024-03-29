# Copyright 2023, Zane Helton, All rights reserved.

defmodule Streamaze.TTS do
  use Retry

  def text_to_speech(text, voice_id, api_key, model_id \\ "eleven_multilingual_v1") do
    url = text_to_speech_url(voice_id)
    headers = [{"Content-Type", "application/json"}, {"xi-api-key", api_key}]
    {:ok, body} = Jason.encode(%{text: strip_urls_from_text(text), model_id: model_id})

    retry with: exponential_backoff() |> randomize |> cap(1_000) |> expiry(10_000) do
      IO.puts("Sending request to ElevenLabs")

      case HTTPoison.post(url, body, headers, timeout: 25_000, recv_timeout: 25_000) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body}

        _ ->
          IO.inspect("Failed ElevenLabs Request: #{url} - #{body}")
          :error
      end
    after
      result -> result
    else
      _ -> {:error, "ElevenLabs error"}
    end
  end

  def list_voices(api_key) do
    url = list_voices_url()
    headers = [{"Content-Type", "application/json"}, {"xi-api-key", api_key}]
    HTTPoison.get!(url, headers) |> Map.get(:body) |> Jason.decode!() |> Map.get("voices")
  end

  defp text_to_speech_url(voice_id) do
    URI.parse("https://api.elevenlabs.io/v1/text-to-speech/#{voice_id}")
    |> URI.to_string()
  end

  defp list_voices_url do
    "https://api.elevenlabs.io/v1/voices"
  end

  defp strip_urls_from_text(text) do
    Regex.replace(~r{https?://\S+}, text, "")
  end
end
