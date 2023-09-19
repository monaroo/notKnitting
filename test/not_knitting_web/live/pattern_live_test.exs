defmodule NotKnittingWeb.PatternLiveTest do
  use NotKnittingWeb.ConnCase

  import Phoenix.LiveViewTest
  import NotKnitting.AccountsFixtures
  import NotKnitting.PatternsFixtures


  @create_attrs %{content: "some content", title: "some title"}
  @update_attrs %{content: "some updated content", title: "some updated title"}
  @invalid_attrs %{content: nil, title: nil}

  defp create_pattern(_) do
    pattern = pattern_fixture()
    %{pattern: pattern}
  end

  describe "Index" do
    setup [:create_pattern]

    test "lists all patterns", %{conn: conn, pattern: pattern} do
      {:ok, _index_live, html} = live(conn, ~p"/patterns")

      assert html =~ "Listing Patterns"
      assert html =~ pattern.content
    end

    test "saves new pattern", %{conn: conn} do
      user = user_fixture()
      pattern = pattern_fixture(%{user: user})
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} = live(conn, ~p"/patterns")

      assert index_live |> element("a", "New Pattern") |> render_click() =~
               "New Pattern"

      assert_patch(index_live, ~p"/patterns/new")

      assert index_live
             |> form("#pattern-form", pattern: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pattern-form", pattern: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/patterns")

      html = render(index_live)
      assert html =~ "Pattern created successfully"
      assert html =~ "some content"
    end

    test "updates pattern in listing", %{conn: conn, pattern: pattern} do
      user = user_fixture()
      pattern = pattern_fixture(%{user: user})
      conn = log_in_user(conn, user)

      {:ok, index_live, _html} = live(conn, ~p"/patterns")


      open_browser(index_live)

      assert index_live |> element("#patterns-#{pattern.id}", "Edit") |> render_click() =~
               "Edit Pattern"

      assert_patch(index_live, ~p"/patterns/#{pattern}/edit")

      assert index_live
             |> form("#pattern-form", pattern: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pattern-form", pattern: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/patterns")

      html = render(index_live)
      assert html =~ "Pattern updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes pattern in listing", %{conn: conn} do
      user = user_fixture()
      pattern = pattern_fixture(%{user: user})
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/patterns")


      assert index_live |> element("#patterns-#{pattern.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#patterns-#{pattern.id}")
    end
  end

  describe "Show" do
    setup [:create_pattern]

    test "displays pattern", %{conn: conn, pattern: pattern} do
      {:ok, _show_live, html} = live(conn, ~p"/patterns/#{pattern}")

      assert html =~ "Show Pattern"
      assert html =~ pattern.content
    end

    test "updates pattern within modal", %{conn: conn, pattern: pattern} do
      user = user_fixture()
      pattern = pattern_fixture(%{user: user})
      conn = log_in_user(conn, user)

      {:ok, show_live, _html} = live(conn, ~p"/patterns/#{pattern}")


      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pattern"

      assert_patch(show_live, ~p"/patterns/#{pattern}/show/edit")

      assert show_live
             |> form("#pattern-form", pattern: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pattern-form", pattern: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/patterns/#{pattern}")

      html = render(show_live)
      assert html =~ "Pattern updated successfully"
      assert html =~ "some updated content"
    end
  end
end
