defmodule NotKnitting.PatternsTest do
  use NotKnitting.DataCase

  alias NotKnitting.Patterns

  describe "patterns" do
    alias NotKnitting.Patterns.Pattern

    import NotKnitting.PatternsFixtures

    @invalid_attrs %{content: nil, title: nil}

    test "list_patterns/0 returns all patterns" do
      pattern = pattern_fixture()
      assert Patterns.list_patterns() == [pattern]
    end

    test "get_pattern!/1 returns the pattern with given id" do
      pattern = pattern_fixture()
      assert Patterns.get_pattern!(pattern.id) == pattern
    end

    test "create_pattern/1 with valid data creates a pattern" do
      valid_attrs = %{content: "some content", title: "some title"}

      assert {:ok, %Pattern{} = pattern} = Patterns.create_pattern(valid_attrs)
      assert pattern.content == "some content"
      assert pattern.title == "some title"
    end

    test "create_pattern/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patterns.create_pattern(@invalid_attrs)
    end

    test "update_pattern/2 with valid data updates the pattern" do
      pattern = pattern_fixture()
      update_attrs = %{content: "some updated content", title: "some updated title"}

      assert {:ok, %Pattern{} = pattern} = Patterns.update_pattern(pattern, update_attrs)
      assert pattern.content == "some updated content"
      assert pattern.title == "some updated title"
    end

    test "update_pattern/2 with invalid data returns error changeset" do
      pattern = pattern_fixture()
      assert {:error, %Ecto.Changeset{}} = Patterns.update_pattern(pattern, @invalid_attrs)
      assert pattern == Patterns.get_pattern!(pattern.id)
    end

    test "delete_pattern/1 deletes the pattern" do
      pattern = pattern_fixture()
      assert {:ok, %Pattern{}} = Patterns.delete_pattern(pattern)
      assert_raise Ecto.NoResultsError, fn -> Patterns.get_pattern!(pattern.id) end
    end

    test "change_pattern/1 returns a pattern changeset" do
      pattern = pattern_fixture()
      assert %Ecto.Changeset{} = Patterns.change_pattern(pattern)
    end
  end
end
