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
      assert %{"success" => true} = res
      assert ^saved_list = list
  end

  describe "GET /entries" do
    test "key and value are given", %{conn: conn} do
      list_name = "get_entries_name"
      key = "key"
      value = "value"
      list = %{key => value}

      Todo.Repo.insert!(%Todo.TodoList{name: list_name, list: list})

      res =
        conn
        |> get(todo_path(conn, :entries, list_name: list_name, key: key, value: value))
        |> json_response(200)

      assert ^res = [list]
    end
  end
end
