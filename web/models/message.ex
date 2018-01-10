defmodule Chatter.Message do
  use Chatter.Web, :model

  schema "message" do
    field :message, :string
    belongs_to :room, Chatter.Room
    belongs_to :from_user, Chatter.FromUser
    belongs_to :to_user, Chatter.ToUser

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message])
    |> validate_required([:message])
  end
end
