defmodule NotKnitting.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table (:replies) do
      add :content, :text
      add :message_id, references(:messages, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:replies, [:message_id])
  end
end
