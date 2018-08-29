defmodule TodoWeb.TodoController do
  use TodoWeb, :controller

  def entries(conn, _params) do
    json conn, %{message: "did it!"}
  end
end
