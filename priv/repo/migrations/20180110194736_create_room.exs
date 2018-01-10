defmodule Chatter.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:room) do
      add :root, :string
      add :is_enabled, :boolean, default: false, null: false

      timestamps()
    end

  end
end
