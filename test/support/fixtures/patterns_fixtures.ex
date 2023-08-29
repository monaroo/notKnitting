defmodule NotKnitting.PatternsFixtures do

  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotKnitting.Patterns` context.
  """
  alias NotKnitting.AccountsFixtures
  @doc """
  Generate a pattern.
  """
  def pattern_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()
    {:ok, pattern} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        user_id: user.id
              })
      |> NotKnitting.Patterns.create_pattern()

    pattern
  end
end
