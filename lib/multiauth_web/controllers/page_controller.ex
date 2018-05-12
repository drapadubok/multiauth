defmodule MultiauthWeb.PageController do
  use MultiauthWeb, :controller

  alias Multiauth.Auth
  alias Multiauth.Auth.User
  alias Multiauth.Auth.Guardian

  def index(conn, _params) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    message = case maybe_user do
      nil -> "Nobody logged in"
      _ -> "Someone is logged in"
    end
    conn
    |> put_flash(:info, message)
    |> render("index.html", changeset: changeset, action: page_path(conn, :login), maybe_user: maybe_user)
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Auth.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Welcome back!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/secret")
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: "/")
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  def secret(conn, _params) do
    render(conn, "secret.html")
  end

end
