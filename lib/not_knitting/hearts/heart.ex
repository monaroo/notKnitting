defmodule NotKnitting.Hearts.Heart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hearts" do
    belongs_to :pattern, NotKnitting.Patterns.Pattern
    belongs_to :user, NotKnitting.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(heart, attrs) do
    heart
    |> cast(attrs, [:pattern_id, :user_id])
    |> validate_required([:pattern_id, :user_id])
    |> foreign_key_constraint(:pattern_id)
    |> foreign_key_constraint(:user_id)
  end
end
