defmodule Multiauth.Auth.Guardian do
  use Guardian, otp_app: :multiauth
  use SansPassword

  alias Multiauth.Auth
  alias Multiauth.Auth.User
  alias Multiauth.Auth.Mailer

  def subject_for_token(user = %User{}, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  def resource_from_claims(%{"sub" => uid}) do
    user = uid
    |> Auth.get_user!
    {:ok, user}
  end

  def resource_from_claims(_) do
    {:error, :invalid_claims}
  end

  def deliver_magic_link(user, magic_token, extra_params) do
    user
    |> Mailer.magic_link_email(magic_token, extra_params)
    |> Mailer.deliver_now
  end
end
