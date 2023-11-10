defmodule NotKnitting.Patterns.Pattern do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "patterns" do
    field :content, :string
    field :title, :string
    field :photo, NotKnitting.Photo.Type
    belongs_to :user, NotKnitting.Accounts.User
    has_many :comments, NotKnitting.Comments.Comment
    has_many :hearts, NotKnitting.Hearts.Heart

    timestamps()
  end

  @doc false
  def changeset(pattern, attrs) do
    pattern
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end

  def photo_changeset(pattern, attrs) do
    pattern
    |> cast_attachments(attrs, [:photo])
  end
end
