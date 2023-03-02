defmodule StreamazeWeb.StreamerLiveTest do
  use StreamazeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Streamaze.StreamsFixtures

  @create_attrs %{name: "some name", youtube_url: "some youtube_url"}
  @update_attrs %{name: "some updated name", youtube_url: "some updated youtube_url"}
  @invalid_attrs %{name: nil, youtube_url: nil}

  defp create_streamer(_) do
    streamer = streamer_fixture()
    %{streamer: streamer}
  end

  describe "Index" do
    setup [:create_streamer]

    test "lists all streamers", %{conn: conn, streamer: streamer} do
      {:ok, _index_live, html} = live(conn, Routes.streamer_index_path(conn, :index))

      assert html =~ "Listing Streamers"
      assert html =~ streamer.name
    end

    test "saves new streamer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.streamer_index_path(conn, :index))

      assert index_live |> element("a", "New Streamer") |> render_click() =~
               "New Streamer"

      assert_patch(index_live, Routes.streamer_index_path(conn, :new))

      assert index_live
             |> form("#streamer-form", streamer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#streamer-form", streamer: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.streamer_index_path(conn, :index))

      assert html =~ "Streamer created successfully"
      assert html =~ "some name"
    end

    test "updates streamer in listing", %{conn: conn, streamer: streamer} do
      {:ok, index_live, _html} = live(conn, Routes.streamer_index_path(conn, :index))

      assert index_live |> element("#streamer-#{streamer.id} a", "Edit") |> render_click() =~
               "Edit Streamer"

      assert_patch(index_live, Routes.streamer_index_path(conn, :edit, streamer))

      assert index_live
             |> form("#streamer-form", streamer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#streamer-form", streamer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.streamer_index_path(conn, :index))

      assert html =~ "Streamer updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes streamer in listing", %{conn: conn, streamer: streamer} do
      {:ok, index_live, _html} = live(conn, Routes.streamer_index_path(conn, :index))

      assert index_live |> element("#streamer-#{streamer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#streamer-#{streamer.id}")
    end
  end

  describe "Show" do
    setup [:create_streamer]

    test "displays streamer", %{conn: conn, streamer: streamer} do
      {:ok, _show_live, html} = live(conn, Routes.streamer_show_path(conn, :show, streamer))

      assert html =~ "Show Streamer"
      assert html =~ streamer.name
    end

    test "updates streamer within modal", %{conn: conn, streamer: streamer} do
      {:ok, show_live, _html} = live(conn, Routes.streamer_show_path(conn, :show, streamer))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Streamer"

      assert_patch(show_live, Routes.streamer_show_path(conn, :edit, streamer))

      assert show_live
             |> form("#streamer-form", streamer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#streamer-form", streamer: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.streamer_show_path(conn, :show, streamer))

      assert html =~ "Streamer updated successfully"
      assert html =~ "some updated name"
    end
  end
end
