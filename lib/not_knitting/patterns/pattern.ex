defmodule NotKnitting.Patterns.Pattern do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patterns" do
    field :content, :string
    field :title, :string
    field :photo, :string
    belongs_to :user, NotKnitting.Accounts.User
    has_many :comments, NotKnitting.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(pattern, attrs) do
    pattern
    |> cast(attrs, [:title, :content, :user_id, :photo])
    |> validate_required([:title, :content, :user_id])
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end
end
