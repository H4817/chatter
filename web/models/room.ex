defmodule Chatter.Room do
  use Chatter.Web, :model

  schema "room" do
    field :root, :string
    field :is_enabled, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:root, :is_enabled])
    |> validate_required([:root, :is_enabled])
  end
end
