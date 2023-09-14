defmodule NotKnitting.Replies.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field(:content, :string)
    belongs_to(:message, NotKnitting.Messages.Message)
    belongs_to(:user, NotKnitting.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:content, :message_id, :user_id])
    |> validate_required([:content, :message_id, :user_id])
    |> foreign_key_constraint(:message_id)
    |> foreign_key_constraint(:user_id)
  end
end
