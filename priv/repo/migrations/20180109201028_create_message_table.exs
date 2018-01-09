defmodule Chatter.Repo.Migrations.CreateMessageTable do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :room_id, references("room")
      add :from_user, references("user")
      add :to_user, references("user")
      add :message, :string

      timestamps()
    end
  end
end
