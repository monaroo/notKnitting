defmodule NotKnitting.PatternsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotKnitting.Patterns` context.
  """

  @doc """
  Generate a pattern.
  """
  def pattern_fixture(attrs \\ %{}) do
    {:ok, pattern} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title"
      })
      |> NotKnitting.Patterns.create_pattern()

    pattern
  end
end
