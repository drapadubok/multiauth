defmodule MultiauthWeb.Router do
  use MultiauthWeb, :router
  use ExAdmin.Router

  pipeline :auth do
    plug Multiauth.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MultiauthWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    post "/login", PageController, :login
    post "/logout", PageController, :logout
  end

  scope "/", MultiauthWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/secret", PageController, :secret
  end

  scope "/admin", ExAdmin do
    pipe_through [:browser, :auth, :ensure_auth]

    admin_routes()
  end

  scope "/magic", MultiauthWeb do
    pipe_through [:browser, :auth]

    get "/login", MagicController, :new
    post "/create", MagicController, :create
    get "/callback/:magic_token", MagicController, :callback, as: :signin
  end

  scope "/api", MultiauthWeb do
     pipe_through [:api, :auth]

     post "/login", ApiAuthController, :login
     post "/logout", ApiAuthController, :logout
  end

  scope "/api", MultiauthWeb do
     pipe_through [:api, :auth, :ensure_auth]

     get "/json", ApiAuthController, :secret_json_endpoint
  end

end
