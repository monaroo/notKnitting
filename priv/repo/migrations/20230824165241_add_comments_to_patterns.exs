defmodule NotKnitting.Repo.Migrations.AddCommentsToPatterns do
  use Ecto.Migration

  def change do
    alter table(:patterns) do
      add :comment_id, references(:comments, on_delete: :delete_all)
    end
  end
end
