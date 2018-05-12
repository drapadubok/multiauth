defmodule Multiauth.Auth.ErrorHandler do
  import Plug.Conn
  require Logger

  def auth_error(conn, {type, reason}, _opts) do
    Logger.info("Auth error, #{inspect(reason)}")
    body = to_string(type)
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
