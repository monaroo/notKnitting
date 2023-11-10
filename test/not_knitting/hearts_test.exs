defmodule NotKnitting.HeartsTest do
  use NotKnitting.DataCase

  alias NotKnitting.Hearts

  describe "hearts" do
    alias NotKnitting.Hearts.Heart

    import NotKnitting.HeartsFixtures

    @invalid_attrs %{}

    test "list_hearts/0 returns all hearts" do
      heart = heart_fixture()
      assert Hearts.list_hearts() == [heart]
    end

    test "get_heart!/1 returns the heart with given id" do
      heart = heart_fixture()
      assert Hearts.get_heart!(heart.id) == heart
    end

    test "create_heart/1 with valid data creates a heart" do
      valid_attrs = %{}

      assert {:ok, %Heart{} = heart} = Hearts.create_heart(valid_attrs)
    end

    test "create_heart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hearts.create_heart(@invalid_attrs)
    end

    test "update_heart/2 with valid data updates the heart" do
      heart = heart_fixture()
      update_attrs = %{}

      assert {:ok, %Heart{} = heart} = Hearts.update_heart(heart, update_attrs)
    end

    test "update_heart/2 with invalid data returns error changeset" do
      heart = heart_fixture()
      assert {:error, %Ecto.Changeset{}} = Hearts.update_heart(heart, @invalid_attrs)
      assert heart == Hearts.get_heart!(heart.id)
    end

    test "delete_heart/1 deletes the heart" do
      heart = heart_fixture()
      assert {:ok, %Heart{}} = Hearts.delete_heart(heart)
      assert_raise Ecto.NoResultsError, fn -> Hearts.get_heart!(heart.id) end
    end

    test "change_heart/1 returns a heart changeset" do
      heart = heart_fixture()
      assert %Ecto.Changeset{} = Hearts.change_heart(heart)
    end
  end
end
