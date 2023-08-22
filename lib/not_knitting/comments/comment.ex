defmodule NotKnitting.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:content, :string)
    belongs_to(:pattern, NotKnitting.Patterns.Pattern)
    belongs_to(:user, NotKnitting.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    # |> IO.inspect()
    |> cast(attrs, [:content, :pattern_id, :user_id])
    |> validate_required([:content, :pattern_id, :user_id])
    |> foreign_key_constraint(:pattern_id)
    |> foreign_key_constraint(:user_id)
  end
end
