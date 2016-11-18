# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :ui, Ui.Endpoint,
  http: [port: 4000], # this config makes difference!
  url: [host: "localhost", port: 4000],
  secret_key_base: "IKa39sPjgUkVWVV98w1z14BkfYq+QiwlSYZu/9tUuuOhoqTHYimRaxXZbPG4NkwV",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: Ui.ErrorView, accepts: ~w(html json)]

# Configures Elixir's Logger
config :logger, :console,
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
