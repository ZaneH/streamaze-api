defmodule StreamazeWeb.PaypalWebhookController do
  use StreamazeWeb, :controller

  @verification_url "https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature"
  @auth_token_url "https://api-m.sandbox.paypal.com/v1/oauth2/token"

  defp get_auth_token do
    headers = [
      Accept: "application/json",
      "Accept-Language": "en_US"
    ]

    client_id = System.get_env("PAYPAL_CLIENT_ID")
    client_secret = System.get_env("PAYPAL_SECRET_KEY")

    options = [
      hackney: [basic_auth: {client_id, client_secret}]
    ]

    body = "grant_type=client_credentials"

    case HTTPoison.post(@auth_token_url, body, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"access_token" => access_token} = Jason.decode!(body)
        {:ok, access_token}

      error ->
        IO.puts("#{inspect(error)}")
        {:error, :no_access_token}
    end
  end

  defp verify_event(conn, auth_token, raw_body) do
    headers = [
      "Content-Type": "application/json",
      Authorization: "Bearer #{auth_token}"
    ]

    body =
      %{
        transmission_id: get_header(conn, "paypal-transmission-id"),
        transmission_time: get_header(conn, "paypal-transmission-time"),
        cert_url: get_header(conn, "paypal-cert-url"),
        auth_algo: get_header(conn, "paypal-auth-algo"),
        transmission_sig: get_header(conn, "paypal-transmission-sig"),
        webhook_id: System.get_env("PAYPAL_WEBHOOK_ID"),
        webhook_event: raw_body
      }
      |> Jason.encode!()

    # Check if the string "raw_body" is present in the JSON-encoded body
    body =
      if String.contains?(body, "\"raw_body\"") do
        String.replace(body, "\"raw_body\"", raw_body)
      else
        body
      end

    with {:ok, %{status_code: 200, body: encoded_body}} <-
           HTTPoison.post(@verification_url, body, headers),
         {:ok, %{"verification_status" => "SUCCESS"}} <- Jason.decode(encoded_body) do
      :ok
    else
      error ->
        IO.puts("#{inspect(error)}")
        {:error, :not_verified}
    end
  end

  defp get_header(conn, key) do
    conn |> get_req_header(key) |> List.first()
  end

  def index(conn, params) do
    IO.inspect(params)

    case get_auth_token() do
      {:ok, access_token} ->
        case verify_event(conn, access_token, params["raw_body"]) do
          :ok ->
            send_resp(conn, 200, "Webhook Verified")

          {:error, reason} ->
            send_resp(conn, 400, "Webhook Verification Failed: #{reason}")
        end

      {:error, _reason} ->
        send_resp(conn, 500, "Failed to obtain access token")
    end
  end
end
