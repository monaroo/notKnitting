defmodule NotKnitting.Hearts do
  @moduledoc """
  The Hearts context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Hearts.Heart

  @doc """
  Returns the list of hearts.

  ## Examples

      iex> list_hearts()
      [%Heart{}, ...]

  """
  def list_hearts do
    Repo.all(Heart)
  end

  @doc """
  Gets a single heart.

  Raises `Ecto.NoResultsError` if the Heart does not exist.

  ## Examples

      iex> get_heart!(123)
      %Heart{}

      iex> get_heart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_heart!(id), do: Repo.get!(Heart, id)

  @doc """
  Creates a heart.

  ## Examples

      iex> create_heart(%{field: value})
      {:ok, %Heart{}}

      iex> create_heart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_heart(attrs \\ %{}) do
    %Heart{}
    |> Heart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a heart.

  ## Examples

      iex> update_heart(heart, %{field: new_value})
      {:ok, %Heart{}}

      iex> update_heart(heart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_heart(%Heart{} = heart, attrs) do
    heart
    |> Heart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a heart.

  ## Examples

      iex> delete_heart(heart)
      {:ok, %Heart{}}

      iex> delete_heart(heart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_heart(%Heart{} = heart) do
    Repo.delete(heart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking heart changes.

  ## Examples

      iex> change_heart(heart)
      %Ecto.Changeset{data: %Heart{}}

  """
  def change_heart(%Heart{} = heart, attrs \\ %{}) do
    Heart.changeset(heart, attrs)
  end
end
