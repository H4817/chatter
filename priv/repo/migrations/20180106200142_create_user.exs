defmodule Chatter.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string
      add :password, :string

      timestamps()
    end
    create unique_index(:user, [:name])

  end
end
