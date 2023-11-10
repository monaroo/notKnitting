defmodule NotKnitting.Repo.Migrations.CreateHearts do
  use Ecto.Migration

  def change do
    create table(:hearts) do
      add :pattern_id, references(:patterns, on_delete: :delete_all), null: false
      add :user_id, references(:patterns, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:hearts, [:pattern_id])
    create index(:hearts, [:user_id])
  end
end
