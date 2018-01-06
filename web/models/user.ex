defmodule Chatter.User do
  use Chatter.Web, :model

  schema "user" do
    field :name, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
    |> unique_constraint(:name)
  end
end
