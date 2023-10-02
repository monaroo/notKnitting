defmodule NotKnitting.Favorites.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorites" do

    timestamps()
  end

  @doc false
  # def changeset(message, attrs) do
  #   message
  #   |> cast(attrs, [:content, :user_id])
  #   |> validate_required([:content, :user_id])
  #   |> foreign_key_constraint(:user_id)
  # end
end
