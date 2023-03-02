defmodule StreamazeWeb.LiveStreamLiveTest do
  use StreamazeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Streamaze.StreamsFixtures

  @create_attrs %{donation_goal: 120.5, donation_goal_currency: "some donation_goal_currency", is_live: true, is_subathon: true, subathon_minutes_per_dollar: 120.5, subathon_seconds_added: 120.5, subathon_start_minutes: 120.5}
  @update_attrs %{donation_goal: 456.7, donation_goal_currency: "some updated donation_goal_currency", is_live: false, is_subathon: false, subathon_minutes_per_dollar: 456.7, subathon_seconds_added: 456.7, subathon_start_minutes: 456.7}
  @invalid_attrs %{donation_goal: nil, donation_goal_currency: nil, is_live: false, is_subathon: false, subathon_minutes_per_dollar: nil, subathon_seconds_added: nil, subathon_start_minutes: nil}

  defp create_live_stream(_) do
    live_stream = live_stream_fixture()
    %{live_stream: live_stream}
  end

  describe "Index" do
    setup [:create_live_stream]

    test "lists all live_streams", %{conn: conn, live_stream: live_stream} do
      {:ok, _index_live, html} = live(conn, Routes.live_stream_index_path(conn, :index))

      assert html =~ "Listing Live streams"
      assert html =~ live_stream.donation_goal_currency
    end

    test "saves new live_stream", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.live_stream_index_path(conn, :index))

      assert index_live |> element("a", "New Live stream") |> render_click() =~
               "New Live stream"

      assert_patch(index_live, Routes.live_stream_index_path(conn, :new))

      assert index_live
             |> form("#live_stream-form", live_stream: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#live_stream-form", live_stream: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.live_stream_index_path(conn, :index))

      assert html =~ "Live stream created successfully"
      assert html =~ "some donation_goal_currency"
    end

    test "updates live_stream in listing", %{conn: conn, live_stream: live_stream} do
      {:ok, index_live, _html} = live(conn, Routes.live_stream_index_path(conn, :index))

      assert index_live |> element("#live_stream-#{live_stream.id} a", "Edit") |> render_click() =~
               "Edit Live stream"

      assert_patch(index_live, Routes.live_stream_index_path(conn, :edit, live_stream))

      assert index_live
             |> form("#live_stream-form", live_stream: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#live_stream-form", live_stream: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.live_stream_index_path(conn, :index))

      assert html =~ "Live stream updated successfully"
      assert html =~ "some updated donation_goal_currency"
    end

    test "deletes live_stream in listing", %{conn: conn, live_stream: live_stream} do
      {:ok, index_live, _html} = live(conn, Routes.live_stream_index_path(conn, :index))

      assert index_live |> element("#live_stream-#{live_stream.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#live_stream-#{live_stream.id}")
    end
  end

  describe "Show" do
    setup [:create_live_stream]

    test "displays live_stream", %{conn: conn, live_stream: live_stream} do
      {:ok, _show_live, html} = live(conn, Routes.live_stream_show_path(conn, :show, live_stream))

      assert html =~ "Show Live stream"
      assert html =~ live_stream.donation_goal_currency
    end

    test "updates live_stream within modal", %{conn: conn, live_stream: live_stream} do
      {:ok, show_live, _html} = live(conn, Routes.live_stream_show_path(conn, :show, live_stream))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Live stream"

      assert_patch(show_live, Routes.live_stream_show_path(conn, :edit, live_stream))

      assert show_live
             |> form("#live_stream-form", live_stream: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#live_stream-form", live_stream: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.live_stream_show_path(conn, :show, live_stream))

      assert html =~ "Live stream updated successfully"
      assert html =~ "some updated donation_goal_currency"
    end
  end
end
