defmodule Chatter.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :message, :string
      add :room_id, references(:room, on_delete: :nothing)
      add :from_user, references(:user, on_delete: :nothing)
      add :to_user, references(:user, on_delete: :nothing)

      timestamps()
    end
    create index(:message, [:room_id])
    create index(:message, [:from_user])
    create index(:message, [:to_user])

  end
end
