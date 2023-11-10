defmodule NotKnitting.HeartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotKnitting.Hearts` context.
  """

  @doc """
  Generate a heart.
  """
  def heart_fixture(attrs \\ %{}) do
    {:ok, heart} =
      attrs
      |> Enum.into(%{

      })
      |> NotKnitting.Hearts.create_heart()

    heart
  end
end
