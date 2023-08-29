defmodule NotKnitting.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias NotKnitting.Repo

  alias NotKnitting.Messages.Message

  @doc """
  Returns the list of messages.


  """
  def list_messages do
    Repo.all(Message)
    |> Repo.preload([:user])
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the message does not exist.


  """
  def get_message!(id), do: Repo.get!(Message, id) |> Repo.preload([:user])

  @doc """
  Creates a message.

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> preloaded_message()
  end

  @doc """
  Updates a message.

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> preloaded_message()
  end

  @doc """
  Deletes a message.

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.


  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  defp preloaded_message({:ok, message}) do
    message = Repo.preload(message, [:user])
    {:ok, message}
  end

  defp preloaded_message(error), do: error

end
