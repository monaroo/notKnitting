defmodule NotKnitting.Tags do
  @moduledoc """
  The Tags context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Tags.Tag

  @doc """
  Returns the list of patterns.

  ## Examples

      iex> list_patterns()
      [%Pattern{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
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
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a pattern.

  ## Examples

      iex> create_pattern(%{field: value})
      {:ok, %Pattern{}}

      iex> create_pattern(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pattern.

  ## Examples

      iex> update_pattern(pattern, %{field: new_value})
      {:ok, %Pattern{}}

      iex> update_pattern(pattern, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pattern.

  ## Examples

      iex> delete_pattern(pattern)
      {:ok, %Pattern{}}

      iex> delete_pattern(pattern)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pattern changes.

  ## Examples

      iex> change_pattern(pattern)
      %Ecto.Changeset{data: %Pattern{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
