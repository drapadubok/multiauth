defmodule MultiauthWeb.ApiAuthController do
  use MultiauthWeb, :controller

  require Logger

  alias Multiauth.Auth
  alias Multiauth.Auth.Guardian
  alias MultiauthWeb.SessionView

  def login(conn, %{"username" => username, "password" => password}) do
    case Auth.authenticate_user(username, password) do
      {:ok, user} ->
        conn = Guardian.Plug.sign_in(conn, user)
        conn
        |> put_status(:created)
        |> render(SessionView, "show.json", jwt: Guardian.Plug.current_token(conn))
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SessionView, "error.json", error: error)
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> render(SessionView, "logout.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(SessionView, "error.json", error: "Not Authenticated")
  end

  def secret_json_endpoint(conn, _params) do
    json(conn, "This is secret stuff")
  end

end
