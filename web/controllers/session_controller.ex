defmodule Chatter.SessionController do
  use Chatter.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, session) do
    case Chatter.Session.login(session, Chatter.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:info, "Wrong username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

end
