defmodule TodoWeb.TodoController do
  use TodoWeb, :controller

  def entries(conn, params) do
    entries =
      params["list_name"]
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(params["key"], params["value"])

    json(conn, entries)
  end
end
