defmodule NotKnitting.Replies do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Replies.Reply

  @doc """
  Returns the list of comments.


  """
  def list_replies do
    Repo.all(Reply)
    |> Repo.preload([:user, :message])
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the comment does not exist.


  """
  def get_reply!(id), do: Repo.get!(Reply, id) |> Repo.preload([:user, :message])

  @doc """
  Creates a comment.

  """
  def create_reply(attrs \\ %{}) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
    |> preloaded_reply()
  end

  @doc """
  Updates a comment.

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
    |> preloaded_reply()
  end

  @doc """
  Deletes a comment.

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.


  """
  def change_reply(%Reply{} = reply, attrs \\ %{}) do
    Reply.changeset(reply, attrs)
  end

  defp preloaded_reply({:ok, reply}) do
    reply = Repo.preload(reply, [:user, :message])
    {:ok, reply}
  end

  defp preloaded_reply(error), do: error

end
