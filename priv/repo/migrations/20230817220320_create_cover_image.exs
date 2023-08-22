defmodule NotKnitting.Repo.Migrations.CreateCoverImage do
  use Ecto.Migration

  def change do
    create table(:cover_images) do
      add :url, :text
      add :pattern_id, references(:patterns, on_delete: :delete_all)

      timestamps()
    end

    create index(:cover_images, [:pattern_id])
  end
end
