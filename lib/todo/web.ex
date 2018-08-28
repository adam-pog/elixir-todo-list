defmodule Todo.Web do
  require Logger

  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.Logger
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Poison)
  plug :match
  plug :dispatch

  post "/add_entry" do
    list_name = conn.params["list_name"]
    list = conn.params["list"]
    Logger.info "Adding entry #{inspect list} for list #{list_name}"

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
    Logger.info "Getting entries for list #{list_name} with kv pair: #{key}: #{value}"

    entries =
      list_name
      |> Todo.Cache.server_process()
      |> Todo.Server.entries(key, value)
      |> Poison.encode!

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, entries)
  end

  def child_spec(_arg) do
    Logger.info "starting web on port: #{Application.fetch_env!(:todo, :http_port)}"
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.fetch_env!(:todo, :http_port)],
      plug: __MODULE__
    )
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    send_resp(conn, conn.status, "Woops")
  end
end
