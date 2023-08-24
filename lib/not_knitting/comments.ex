defmodule NotKnitting.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Comments.Comment

  @doc """
  Returns the list of comments.


  """
  def list_comments do
    Repo.all(Comment)
    |> Repo.preload([:user, :pattern])
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the comment does not exist.


  """
  def get_comment!(id), do: Repo.get!(Comment, id) |> Repo.preload([:user, :pattern])

  @doc """
  Creates a comment.

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
    |> preloaded_comment()
  end

  @doc """
  Updates a comment.

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
    |> preloaded_comment()
  end

  @doc """
  Deletes a comment.

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.


  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  defp preloaded_comment({:ok, comment}) do
    comment = Repo.preload(comment, [:user, :pattern])
    {:ok, comment}
  end

  defp preloaded_comment(error), do: error

end
