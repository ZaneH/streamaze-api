defmodule Streamaze.Connectivity.Viewers do
  # alias Wallaby.Browser
  # import Wallaby.Query
  # {:ok, _} = Application.ensure_all_started(:wallaby)
  # {:ok, session} = Wallaby.start_session()

  def start_link(config) do
    link =
      Agent.start_link(
        fn ->
          %{
            "config" => %{
              "kick_channel_name" => config["kick_channel_name"]
            }
          }
        end,
        name: String.to_atom(config["kick_channel_name"])
      )

    case link do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid
    end
  end

  def fetch_kick_viewer_count(pid) do
    try do
      username =
        Agent.get(pid, fn state ->
          state["config"]["kick_channel_name"]
        end)

      response =
        HTTPoison.get(
          "https://hmmwhat.highstreaming.xyz/?url=https://kick.com/api/v2/channels/#{username}",
          [],
          hackney: [:insecure]
        )

      case response do
        {:ok, %{body: body}} ->
          case Jason.decode(body) do
            {:ok, decoded} ->
              livestream = Map.get(decoded, "livestream")

              case livestream do
                nil ->
                  nil

                livestream ->
                  viewer_count = Map.get(livestream, "viewer_count")

                  case viewer_count do
                    nil ->
                      nil

                    viewer_count ->
                      viewer_count
                  end
              end

            {:error, _} ->
              nil
          end

        {:error, _} ->
          nil
      end
    rescue
      e ->
        IO.inspect(e, label: "Error fetching viewer count")
    end
  end

  # def fetch_youtube_viewer_count(pid) do
  #   Agent.get(pid, fn state ->
  #     config = state["config"]
  #     session = state["session"]

  #     session
  #     |> Browser.visit(config["youtube_channel_url"])

  #     error_xpath = Wallaby.Query.xpath("//div[@id='error-page']")

  #     latest_stream_xpath =
  #       Wallaby.Query.xpath(
  #         "//ytd-thumbnail-overlay-time-status-renderer[@overlay-style='LIVE']/ancestor::a"
  #       )

  #     is_error_page =
  #       session
  #       |> Browser.visible?(error_xpath)
  #   end)
  # end

  # def tiktok_viewer_count do
  #   Agent.get(__MODULE__, & &1)
  # end

  # def twitch_viewer_count do
  #   Agent.get(__MODULE__, & &1)
  # end
end
