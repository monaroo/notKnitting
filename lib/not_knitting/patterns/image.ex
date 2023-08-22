defmodule NotKnitting.Patterns.CoverImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :url, :string
    belongs_to :pattern, NotKnitting.Patterns.Pattern
    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url])
  end

end
