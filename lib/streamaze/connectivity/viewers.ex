defmodule Streamaze.Connectivity.Viewers do
  # alias Wallaby.Browser
  # import Wallaby.Query
  # {:ok, _} = Application.ensure_all_started(:wallaby)
  # {:ok, session} = Wallaby.start_session()

  def start_link(config) do
    {:ok, pid} =
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

    pid
  end

  def fetch_kick_viewer_count(pid) do
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
        viewer_count =
          body
          |> Jason.decode!()
          |> Map.get("livestream")
          |> Map.get("viewer_count")

        viewer_count

      {:error, _} ->
        nil
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
