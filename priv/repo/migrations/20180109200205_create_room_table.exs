defmodule Chatter.Repo.Migrations.CreateRoomTable do
  use Ecto.Migration

  def change do
    create table(:room) do
      add :root, :string
      add :is_enabled, :boolean
      timestamps()
    end
  end
end
