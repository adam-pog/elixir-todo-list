require IEx

defmodule Todo.Web do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Logger
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Poison)
  plug :match
  plug :dispatch

  post "/add_entry" do
    list_name = conn.params["list_name"]
    list = conn.params["list"]

    list_name
    |> Todo.Cache.server_process()
    |> Todo.Server.add_entry(list)

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "YOU DID IT")
  end

  get "/entries" do
    list_name = conn.params["list"]
    key = conn.params["key"]
    value = conn.params["value"]

    entries =
      list_name
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(key, value)

    formatted_entries =
      entries
      |> Enum.map(&"#{&1[key]} #{&1[value]}")
      |> Enum.join("\n")

    conn
    |> Plug.Conn.put_resp_content_type("text/plain") #return / accept JSON?
    |> Plug.Conn.send_resp(200, formatted_entries)
  end

  def child_spec(_arg) do
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.fetch_env!(:todo, :http_port)],
      plug: __MODULE__
    )
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    IO.inspect("Something went wrong:")
    IO.inspect reason
  end
end
