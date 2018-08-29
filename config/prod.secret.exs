use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :todo, TodoWeb.Endpoint,
  secret_key_base: "AMMSRAPMTdNlWtpj4OoDsBP4bCa8qyWAI96najdAAmV05GVenv8QRdsaIPY5NLhC"

# Configure your database
config :todo, Todo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todo_prod",
  pool_size: 15
