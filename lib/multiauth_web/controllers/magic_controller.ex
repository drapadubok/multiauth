defmodule MultiauthWeb.MagicController do
  @moduledoc """
    Magic link related controller actions.
  """
  use MultiauthWeb, :controller

  require Logger

  alias Multiauth.Auth
  alias Multiauth.Auth.User
  alias Multiauth.Auth.Guardian
  alias MultiauthWeb.EmailView

  @doc """
    Email input form
  """
  def new(conn, _params) do
    conn
    |> assign(:changeset, Auth.change_user(%User{}))
    |> render(EmailView, "new.html")
  end

  @doc """
    Get or create a user, and send the magic token to that user.
    Guardian.send_magic_link uses Guardian.deliver_magic_link callback.
  """
  def create(conn, %{"user" => %{"email" => email}}) do
    with {:ok, user} <- Auth.get_or_create_by_email(email),
         {:ok, _, _} <- Guardian.send_magic_link(user)
    do
      conn
      |> put_flash(:info, "We have sent you a link for signing in via email to #{email}.")
      |> redirect(to: "/")
    end
  end

  @doc """
    Login user via magic link token.
  """
  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        conn
        |> put_flash(:success, "Welcome!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/admin")
      _ ->
        conn
        |> put_flash(:error, "Invalid magic link")
        |> redirect(to: "/")
    end
  end
end
