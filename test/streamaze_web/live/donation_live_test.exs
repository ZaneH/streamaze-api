defmodule StreamazeWeb.DonationLiveTest do
  use StreamazeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Streamaze.FinancesFixtures

  @create_attrs %{amount: 120.5, currency: "some currency", message: "some message", metadata: %{}, sender: "some sender", type: "some type"}
  @update_attrs %{amount: 456.7, currency: "some updated currency", message: "some updated message", metadata: %{}, sender: "some updated sender", type: "some updated type"}
  @invalid_attrs %{amount: nil, currency: nil, message: nil, metadata: nil, sender: nil, type: nil}

  defp create_donation(_) do
    donation = donation_fixture()
    %{donation: donation}
  end

  describe "Index" do
    setup [:create_donation]

    test "lists all donations", %{conn: conn, donation: donation} do
      {:ok, _index_live, html} = live(conn, Routes.donation_index_path(conn, :index))

      assert html =~ "Listing Donations"
      assert html =~ donation.currency
    end

    test "saves new donation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.donation_index_path(conn, :index))

      assert index_live |> element("a", "New Donation") |> render_click() =~
               "New Donation"

      assert_patch(index_live, Routes.donation_index_path(conn, :new))

      assert index_live
             |> form("#donation-form", donation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#donation-form", donation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.donation_index_path(conn, :index))

      assert html =~ "Donation created successfully"
      assert html =~ "some currency"
    end

    test "updates donation in listing", %{conn: conn, donation: donation} do
      {:ok, index_live, _html} = live(conn, Routes.donation_index_path(conn, :index))

      assert index_live |> element("#donation-#{donation.id} a", "Edit") |> render_click() =~
               "Edit Donation"

      assert_patch(index_live, Routes.donation_index_path(conn, :edit, donation))

      assert index_live
             |> form("#donation-form", donation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#donation-form", donation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.donation_index_path(conn, :index))

      assert html =~ "Donation updated successfully"
      assert html =~ "some updated currency"
    end

    test "deletes donation in listing", %{conn: conn, donation: donation} do
      {:ok, index_live, _html} = live(conn, Routes.donation_index_path(conn, :index))

      assert index_live |> element("#donation-#{donation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#donation-#{donation.id}")
    end
  end

  describe "Show" do
    setup [:create_donation]

    test "displays donation", %{conn: conn, donation: donation} do
      {:ok, _show_live, html} = live(conn, Routes.donation_show_path(conn, :show, donation))

      assert html =~ "Show Donation"
      assert html =~ donation.currency
    end

    test "updates donation within modal", %{conn: conn, donation: donation} do
      {:ok, show_live, _html} = live(conn, Routes.donation_show_path(conn, :show, donation))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Donation"

      assert_patch(show_live, Routes.donation_show_path(conn, :edit, donation))

      assert show_live
             |> form("#donation-form", donation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#donation-form", donation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.donation_show_path(conn, :show, donation))

      assert html =~ "Donation updated successfully"
      assert html =~ "some updated currency"
    end
  end
end
