defmodule Multiauth.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :multiauth,
    error_handler: Multiauth.Auth.ErrorHandler,
    module: Multiauth.Auth.Guardian

  # Validate token if it is in session
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  # Validate authorization header
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}, realm: "Bearer"

  # Load the user if either of the above succeeded
  plug Guardian.Plug.LoadResource, allow_blank: true, ensure: true
end
