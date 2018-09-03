defmodule TodoApi.TodoController do
  use TodoWeb, :controller

  def entries(conn, params) do
    entries =
      params["list_name"]
      |> Todo.Cache.server_process()
      |> entries_from_server(params)

    json(conn, entries)
  end

  def add_entry(conn, params) do
    params["list_name"]
    |> Todo.Cache.server_process()
    |> Todo.Server.add_entry(params["list"])

    json(conn, %{success: true})
  end

  defp entries_from_server(pid, %{"key" => key, "value" => value}) do
    Todo.Server.entries(pid, key, value)
  end

  defp entries_from_server(pid, _) do
    Todo.Server.entries(pid)
  end
end
