defmodule NotKnitting.Repo.Migrations.AddPatternsTagsJoinTable do
  use Ecto.Migration

  def change do
    create table(:patterns_tags, primary_key: false) do
      add :pattern_id, references(:patterns, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create(unique_index(:patterns_tags, [:pattern_id, :tag_id]))
  end
end
