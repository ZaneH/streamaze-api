defmodule Streamaze.TTS do
  use Retry

  def text_to_speech(text, voice_id, api_key) do
    url = text_to_speech_url(voice_id)
    headers = [{"Content-Type", "application/json"}, {"xi-api-key", api_key}]
    {:ok, body} = Jason.encode(%{text: text})

    retry with: exponential_backoff() |> randomize |> cap(1_000) |> expiry(10_000) do
      IO.puts("Sending request to ElevenLabs")

      case HTTPoison.post(url, body, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, body}

        {_, %HTTPoison.Response{body: body}} ->
          IO.inspect(body)
          {:error, "ElevenLabs error. Contact support."}

        _ ->
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
end
