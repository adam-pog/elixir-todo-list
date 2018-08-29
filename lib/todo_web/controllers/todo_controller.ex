defmodule TodoWeb.TodoController do
  use TodoWeb, :controller

  def entries(conn, params) do
    entries =
      params["list_name"]
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(params["key"], params["value"])

    json(conn, entries)
  end

  def add_entry(conn, params) do
    params["list_name"]
    |> Todo.Cache.server_process()
    |> Todo.Server.add_entry(params["list"])

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "Added list to #{params["list_name"]}")
  end
end
