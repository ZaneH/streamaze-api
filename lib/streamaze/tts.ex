defmodule Streamaze.TTS do
  def text_to_speech(text, voice_id, api_key) do
    url = text_to_speech_url(voice_id, api_key)
    headers = [{"Content-Type", "application/json"}]
    body = Jason.encode(%{text: text})
    HTTPoison.post!(url, body, headers)
  end

  def available_voices(api_key) do
    url = available_voices_url()
    headers = [{"Content-Type", "application/json"}, {"xi-api-key", api_key}]
    HTTPoison.get!(url, headers)
  end

  defp text_to_speech_url(voice_id, api_key) do
    URI.parse("https://api.elevenlabs.io/v1/text-to-speech/#{voice_id}")
    |> URI.append_query("xi-api-key=#{api_key}")
    |> URI.to_string()
  end

  defp available_voices_url do
    "https://api.elevenlabs.io/v1/voices"
  end
end
