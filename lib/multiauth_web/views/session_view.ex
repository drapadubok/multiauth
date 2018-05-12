defmodule MultiauthWeb.SessionView do
  use MultiauthWeb, :view

  def render("show.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("logout.json", _) do
    %{ok: true}
  end
end
