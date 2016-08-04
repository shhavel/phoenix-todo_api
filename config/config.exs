# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo_api,
  ecto_repos: [TodoApi.Repo]

# Configures the endpoint
config :todo_api, TodoApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WCaSBIHIqEWLkV06AWs/NDf4I4h/265+kkWQbLE4n0KEmLOF3b68k4uTTJzkVzQ5",
  render_errors: [view: TodoApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: TodoApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
