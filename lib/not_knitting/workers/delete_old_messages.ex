defmodule NotKnitting.Workers.DeleteOldMessages do
  use Oban.Worker, queue: :default, max_attempts: 1

  @impl true
  def perform(_params) do
    NotKnitting.Messages.delete_old_messages()

    :ok
  end
end
