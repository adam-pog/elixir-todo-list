defmodule TodoWeb.TodoControllerTest do
  use TodoWeb.ConnCase
  import Ecto.Query, only: [from: 2]

  test "GET /add_entry", %{conn: conn} do
    list_name = "name"
    list = %{"one" => "two"}

    res =
      conn
      |> post(todo_path(conn, :add_entry, list_name: list_name, list: list))
      |> json_response(200)

      [saved_list] = Todo.Repo.all(
        from entry in Todo.TodoList,
        where: entry.name == ^list_name,
        select: entry.list
      )
      assert res = %{success: true}
      assert ^saved_list = list
  end
end
