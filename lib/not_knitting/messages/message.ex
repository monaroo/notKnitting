defmodule NotKnitting.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:content, :string)
    belongs_to(:user, NotKnitting.Accounts.User)
    has_many :replies, NotKnitting.Replies.Reply

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
