defmodule NotKnitting.Repo.Migrations.AddPhotoToPatterns do
  use Ecto.Migration

  def change do
    alter table(:patterns) do
      add :photo, :text
    end
  end
end
