defmodule Streamaze.StreamsTest do
  use Streamaze.DataCase

  alias Streamaze.Streams

  describe "streamers" do
    alias Streamaze.Streams.Streamer

    import Streamaze.StreamsFixtures

    @invalid_attrs %{name: nil, youtube_url: nil}

    test "list_streamers/0 returns all streamers" do
      streamer = streamer_fixture()
      assert Streams.list_streamers() == [streamer]
    end

    test "get_streamer!/1 returns the streamer with given id" do
      streamer = streamer_fixture()
      assert Streams.get_streamer!(streamer.id) == streamer
    end

    test "create_streamer/1 with valid data creates a streamer" do
      valid_attrs = %{name: "some name", youtube_url: "some youtube_url"}

      assert {:ok, %Streamer{} = streamer} = Streams.create_streamer(valid_attrs)
      assert streamer.name == "some name"
      assert streamer.youtube_url == "some youtube_url"
    end

    test "create_streamer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Streams.create_streamer(@invalid_attrs)
    end

    test "update_streamer/2 with valid data updates the streamer" do
      streamer = streamer_fixture()
      update_attrs = %{name: "some updated name", youtube_url: "some updated youtube_url"}

      assert {:ok, %Streamer{} = streamer} = Streams.update_streamer(streamer, update_attrs)
      assert streamer.name == "some updated name"
      assert streamer.youtube_url == "some updated youtube_url"
    end

    test "update_streamer/2 with invalid data returns error changeset" do
      streamer = streamer_fixture()
      assert {:error, %Ecto.Changeset{}} = Streams.update_streamer(streamer, @invalid_attrs)
      assert streamer == Streams.get_streamer!(streamer.id)
    end

    test "delete_streamer/1 deletes the streamer" do
      streamer = streamer_fixture()
      assert {:ok, %Streamer{}} = Streams.delete_streamer(streamer)
      assert_raise Ecto.NoResultsError, fn -> Streams.get_streamer!(streamer.id) end
    end

    test "change_streamer/1 returns a streamer changeset" do
      streamer = streamer_fixture()
      assert %Ecto.Changeset{} = Streams.change_streamer(streamer)
    end
  end

  describe "live_streams" do
    alias Streamaze.Streams.LiveStream

    import Streamaze.StreamsFixtures

    @invalid_attrs %{donation_goal: nil, donation_goal_currency: nil, is_live: nil, is_subathon: nil, subathon_minutes_per_dollar: nil, subathon_seconds_added: nil, subathon_start_minutes: nil}

    test "list_live_streams/0 returns all live_streams" do
      live_stream = live_stream_fixture()
      assert Streams.list_live_streams() == [live_stream]
    end

    test "get_live_stream!/1 returns the live_stream with given id" do
      live_stream = live_stream_fixture()
      assert Streams.get_live_stream!(live_stream.id) == live_stream
    end

    test "create_live_stream/1 with valid data creates a live_stream" do
      valid_attrs = %{donation_goal: 120.5, donation_goal_currency: "some donation_goal_currency", is_live: true, is_subathon: true, subathon_minutes_per_dollar: 120.5, subathon_seconds_added: 120.5, subathon_start_minutes: 120.5}

      assert {:ok, %LiveStream{} = live_stream} = Streams.create_live_stream(valid_attrs)
      assert live_stream.donation_goal == 120.5
      assert live_stream.donation_goal_currency == "some donation_goal_currency"
      assert live_stream.is_live == true
      assert live_stream.is_subathon == true
      assert live_stream.subathon_minutes_per_dollar == 120.5
      assert live_stream.subathon_seconds_added == 120.5
      assert live_stream.subathon_start_minutes == 120.5
    end

    test "create_live_stream/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Streams.create_live_stream(@invalid_attrs)
    end

    test "update_live_stream/2 with valid data updates the live_stream" do
      live_stream = live_stream_fixture()
      update_attrs = %{donation_goal: 456.7, donation_goal_currency: "some updated donation_goal_currency", is_live: false, is_subathon: false, subathon_minutes_per_dollar: 456.7, subathon_seconds_added: 456.7, subathon_start_minutes: 456.7}

      assert {:ok, %LiveStream{} = live_stream} = Streams.update_live_stream(live_stream, update_attrs)
      assert live_stream.donation_goal == 456.7
      assert live_stream.donation_goal_currency == "some updated donation_goal_currency"
      assert live_stream.is_live == false
      assert live_stream.is_subathon == false
      assert live_stream.subathon_minutes_per_dollar == 456.7
      assert live_stream.subathon_seconds_added == 456.7
      assert live_stream.subathon_start_minutes == 456.7
    end

    test "update_live_stream/2 with invalid data returns error changeset" do
      live_stream = live_stream_fixture()
      assert {:error, %Ecto.Changeset{}} = Streams.update_live_stream(live_stream, @invalid_attrs)
      assert live_stream == Streams.get_live_stream!(live_stream.id)
    end

    test "delete_live_stream/1 deletes the live_stream" do
      live_stream = live_stream_fixture()
      assert {:ok, %LiveStream{}} = Streams.delete_live_stream(live_stream)
      assert_raise Ecto.NoResultsError, fn -> Streams.get_live_stream!(live_stream.id) end
    end

    test "change_live_stream/1 returns a live_stream changeset" do
      live_stream = live_stream_fixture()
      assert %Ecto.Changeset{} = Streams.change_live_stream(live_stream)
    end
  end
end
