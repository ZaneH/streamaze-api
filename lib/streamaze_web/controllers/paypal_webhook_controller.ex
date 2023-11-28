defmodule StreamazeWeb.PaypalWebhookController do
  alias Streamaze.Accounts
  alias Streamaze.Accounts.UserNotifier
  alias Streamaze.Payments
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
        webhook_event: "raw_body"
      }
      |> Jason.encode!()
      |> String.replace("\"raw_body\"", raw_body)

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

  defp maybe_send_email(user_id, event_type) do
    try do
      if event_type == "BILLING.SUBSCRIPTION.ACTIVATED" do
        user = Accounts.get_user!(user_id)
        UserNotifier.deliver_subscription_receipt(user)
      end
    rescue
      _ -> nil
    end
  end

  def index(conn, _params) do
    raw_body = StreamazeWeb.Plugs.CachingBodyReader.get_raw_body(conn)

    case get_auth_token() do
      {:ok, access_token} ->
        case verify_event(
               conn,
               access_token,
               raw_body
             ) do
          :ok ->
            decoded_body = Jason.decode!(raw_body)
            event_type = decoded_body["event_type"]
            event_id = decoded_body["id"]

            data = %{
              event_type: event_type,
              event_id: event_id,
              raw_body: raw_body
            }

            resource_id = decoded_body["resource"]["id"]

            user_id = Payments.get_user_id_from_resource_id(resource_id)

            case user_id do
              nil ->
                send_resp(conn, 400, "User not found")

              _ ->
                case Payments.create_paypal_event(Map.put(data, :user_id, user_id)) do
                  {:ok, _} ->
                    maybe_send_email(user_id, event_type)
                    send_resp(conn, 200, "OK")

                  {:error, err} ->
                    IO.puts("PayPal webhook error: #{inspect(err)}")
                    send_resp(conn, 400, "Error creating PayPal event")
                end
            end

          {:error, reason} ->
            IO.puts("PayPal webhook error: #{inspect(reason)}")
            send_resp(conn, 400, "Webhook Verification Failed")
        end

      {:error, reason} ->
        IO.puts("PayPal webhook error: #{inspect(reason)}")
        send_resp(conn, 500, "Failed to obtain access token")
    end
  end
end
