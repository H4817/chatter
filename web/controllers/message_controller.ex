defmodule Chatter.MessageController do
  use Chatter.Web, :controller

  alias Chatter.Message
  alias Chatter.User
  alias Chatter.Session

  def index(conn, _params) do
    message = IO.inspect(Repo.all(Message) |> Repo.preload([:room, :from_user, :to_user]))
    render(conn, "index.html", message: message)
  end

  def new(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    current_user = Session.current_user(conn)
    case current_user do
      nil ->  conn
              |> put_flash(:error, "You should authorize first.")
              |> redirect(to: message_path(conn, :index))
      _ ->
    changeset = Message.changeset(%Message{}, message_params)

    to_user_id = if (message_params["to_user_id"] != ""), do:
     message_params["to_user_id"] |> String.to_integer, else:
     message_params["to_user_id"]

    changeset_with_users = if is_integer(to_user_id), do:
      Ecto.Changeset.put_assoc(changeset, :from_user, current_user)
      |> Ecto.Changeset.put_assoc(:to_user, Repo.get(User, to_user_id)), else:
      Ecto.Changeset.put_assoc(changeset, :from_user, current_user)
    
      case Repo.insert(changeset_with_users) do
        {:ok, _message} ->
          conn
          |> put_flash(:info, "Message created successfully.")
          |> redirect(to: message_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def view(conn) do
    render(conn, "show.html")
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.html", message: message)
  end

  def edit(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message, message_params)

    case Repo.update(changeset) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: message_path(conn, :show, message))
      {:error, changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: message_path(conn, :index))
  end
end
