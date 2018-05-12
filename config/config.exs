# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :multiauth,
  ecto_repos: [Multiauth.Repo]

# Configures the endpoint
config :multiauth, MultiauthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TEc+SbOrUYfcUE/SdGjRR3Ey4PYe47KFLNIT65NgdIX76ajTNTtCaou9TxrHo+N7",
  render_errors: [view: MultiauthWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Multiauth.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :multiauth, Multiauth.Auth.Guardian,
  issuer: "Multiauth.#{Mix.env}",
  ttl: {60, :minutes},
  token_ttl: %{
    "magic" => {30, :minutes},
    "access" => {1, :days}
  },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :ex_admin,
  repo: Multiauth.Repo,
  module: MultiauthWeb,
  modules: [
    Multiauth.ExAdmin.Dashboard,
  ]

config :multiauth, Multiauth.Auth.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}
