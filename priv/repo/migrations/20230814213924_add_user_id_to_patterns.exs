defmodule NotKnitting.Repo.Migrations.AddUserIdToPatterns do
  use Ecto.Migration

  def change do
    alter table(:patterns) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
