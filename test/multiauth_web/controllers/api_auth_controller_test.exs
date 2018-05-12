defmodule MultiauthWeb.ApiAuthControllerTest do
  use MultiauthWeb.ConnCase
  alias Multiauth.Auth

  @valid_attrs %{email: "auth_email", password: "auth_password", username: "auth_username"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Auth.create_user()
    user
  end

  test "GET /api/json with authenticated user should return 'This is secret stuff'", %{conn: conn} do
    user_fixture()

    # get jwt
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> post("/api/login", username: "auth_username", password: "auth_password")

    # put headers
    conn = conn
    |> recycle()
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", "Bearer #{conn.assigns.jwt}")
    |> get("/api/json")

    assert json_response(conn, 200) =~ "This is secret stuff"
  end

  test "GET /api/json with invalid token should respond with 'invalid token'", %{conn: conn} do
    # put headers
    conn = conn
    |> put_req_header("authorization", "Bearer invalid_token")
    |> get("/api/json")

    assert text_response(conn, 401) =~ "invalid_token"
  end

  test "GET /api/json with non-authenticated user should respond with 'unauthenticated'", %{conn: conn} do
    # put headers
    conn = conn
    |> get("/api/json")

    assert text_response(conn, 401) =~ "unauthenticated"
  end
end
