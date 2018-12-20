# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :test1,
  ecto_repos: [Test1.Repo]

# Configures the endpoint
config :test1, Test1Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OQCxDqn+JGePsAKkeWZzU3mOTZe3Y0625S9TDkUTuO3RXpv86cpsz7Z9xdgqviWs",
  render_errors: [view: Test1Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Test1.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# From updating Phoenix to v1.4
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
