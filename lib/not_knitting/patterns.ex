defmodule NotKnitting.Patterns do
  @moduledoc """
  The Patterns context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Patterns.Pattern

  @doc """
  Returns the list of patterns.

  ## Examples

      iex> list_patterns()
      [%Pattern{}, ...]

  """
  def list_patterns do
    Repo.all(Pattern)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single pattern.

  Raises `Ecto.NoResultsError` if the Pattern does not exist.

  ## Examples

      iex> get_pattern!(123)
      %Pattern{}

      iex> get_pattern!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pattern!(id), do: Repo.get!(Pattern, id) |> Repo.preload(:user)

  @doc """
  Creates a pattern.

  ## Examples

      iex> create_pattern(%{field: value})
      {:ok, %Pattern{}}

      iex> create_pattern(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pattern(attrs \\ %{}) do
    %Pattern{}
    |> Pattern.changeset(attrs)
    |> Repo.insert()
    |> preloaded_pattern()
  end

  @doc """
  Updates a pattern.

  ## Examples

      iex> update_pattern(pattern, %{field: new_value})
      {:ok, %Pattern{}}

      iex> update_pattern(pattern, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pattern(%Pattern{} = pattern, attrs) do
    pattern
    |> Pattern.changeset(attrs)
    |> Repo.update()
    |> preloaded_pattern()
  end

  @doc """
  Deletes a pattern.

  ## Examples

      iex> delete_pattern(pattern)
      {:ok, %Pattern{}}

      iex> delete_pattern(pattern)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pattern(%Pattern{} = pattern) do
    Repo.delete(pattern)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pattern changes.

  ## Examples

      iex> change_pattern(pattern)
      %Ecto.Changeset{data: %Pattern{}}

  """
  def change_pattern(%Pattern{} = pattern, attrs \\ %{}) do
    Pattern.changeset(pattern, attrs)
  end

  defp preloaded_pattern({:ok, pattern}) do
    pattern = Repo.preload(pattern, :user)
    {:ok, pattern}
  end

  defp preloaded_pattern(error), do: error

end
