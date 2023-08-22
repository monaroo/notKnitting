defmodule NotKnitting.Repo.Migrations.CreatePatterns do
  use Ecto.Migration

  def change do
    create table(:patterns) do
      add :title, :string
      add :content, :text

      timestamps()
    end
  end
end
