defmodule Multiauth.Auth.Mailer do
  use Bamboo.Mailer, otp_app: :multiauth
  use Bamboo.Phoenix, view: MultiauthWeb.EmailView

  import Bamboo.Email

  def magic_link_email(user, magic_token, _extra_params) do
    new_email()
    |> to(user.email)
    |> from("info@overmind.fi")
    |> subject("Your login link for Overmind")
    |> assign(:token, magic_token)
    |> render("magic_link.html")
  end
end
