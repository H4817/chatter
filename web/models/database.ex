# needed to get defdatabase and other macros
use Amnesia

# defines a database called Database, it's basically a defmodule with
# some additional magic
defdatabase chatter_dev do
  # this is just a forward declaration of the table, otherwise you'd have
  # to fully scope User.read in Message functions
  deftable User

  # this defines a table with an user_id key and a content attribute, and
  # makes the table a bag; tables are basically records with a bunch of helpers
  deftable Message, [:from_user, :to_user, :content], type: :bag do
    # this isn't required, but it's always nice to spec things
    @type t :: %Message{from_user: integer, to_user: integer, content: String.t}

    # this defines a helper function to fetch the user from a Message record
    def from_user(self) do
      User.read(self.from_user)
    end

    # this does the same, but uses dirty operations
    def from_user!(self) do
      User.read!(self.from_user)
    end

    # this defines a helper function to fetch the user from a Message record
    def to_user(self) do
      User.read(self.to_user)
    end

    # this does the same, but uses dirty operations
    def to_user!(self) do
      User.read!(self.to_user)
    end

  end

  # this defines a table with other attributes as ordered set, and defines an
  # additional index as email, this improves lookup operations
  deftable User, [{ :id, autoincrement }, :name, :password], type: :ordered_set, index: [:name] do
    # again not needed, but nice to have
    @type t :: %User{id: non_neg_integer, name: String.t, password: String.t}

    # this is a helper function to add a message to the user, using write
    # on the created records makes it write to the mnesia table
    def add_message(self, content) do
      %Message{from_user: self.id, content: content} |> Message.write
    end

    # like above, but again with dirty operations, the bang methods are used
    # thorough amnesia to be the dirty counterparts of the bang-less functions
    def add_message!(self, content) do
      %Message{from_user: self.id, content: content} |> Message.write!
    end

    # this is a helper to fetch all messages for the user
    def messages(self) do
      Message.read(self.id)
    end

    # like above, but with dirty operations
    def messages!(self) do
      Message.read!(self.id)
    end
  end
end
