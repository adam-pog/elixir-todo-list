Code.load_file("test/todo/mocks/database_mock.exs")
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Todo.Repo, :manual)
