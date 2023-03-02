defmodule Streamaze.StreamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Streamaze.Streams` context.
  """

  @doc """
  Generate a streamer.
  """
  def streamer_fixture(attrs \\ %{}) do
    {:ok, streamer} =
      attrs
      |> Enum.into(%{
        name: "some name",
        youtube_url: "some youtube_url"
      })
      |> Streamaze.Streams.create_streamer()

    streamer
  end

  @doc """
  Generate a live_stream.
  """
  def live_stream_fixture(attrs \\ %{}) do
    {:ok, live_stream} =
      attrs
      |> Enum.into(%{
        donation_goal: 120.5,
        donation_goal_currency: "some donation_goal_currency",
        is_live: true,
        is_subathon: true,
        subathon_minutes_per_dollar: 120.5,
        subathon_seconds_added: 120.5,
        subathon_start_minutes: 120.5
      })
      |> Streamaze.Streams.create_live_stream()

    live_stream
  end
end
