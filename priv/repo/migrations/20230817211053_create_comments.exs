defmodule NotKnitting.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :pattern_id, references(:patterns, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:pattern_id])
  end
end
