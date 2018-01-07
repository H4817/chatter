defmodule Chatter.Session do
  alias Chatter.User

  def login(params, repo) do
    user = repo.get_by(User, name: String.downcase(params["name"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> password == user.password
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Chatter.Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)

end
