defmodule NotKnitting.Repo.Migrations.AddRepliesToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :reply_id, references(:replies, on_delete: :delete_all)
    end
  end
end
