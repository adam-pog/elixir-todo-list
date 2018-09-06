defmodule TodoServerTest do
  use Todo.DataCase
  import Ecto.Query, only: [from: 2]

  test "add_entry" do
    new_entry = %{"key" => "value"}
    list_name = "name"
    result = Todo.Server.handle_call({:add_entry, new_entry}, nil, {list_name, []})
    [saved_list] = Todo.Repo.all(
      from entry in Todo.TodoList,
      where: entry.name == ^list_name,
      select: entry.list
    )

    assert ^result = {:reply, :success, {list_name, [new_entry]}, :timer.seconds(30)}
    assert ^saved_list = new_entry
  end

  test "entries/3" do
    key = "key"
    value = "value"
    list = %{key => value}
    list2 = %{"key2" => "value2"}
    list_name = "name"

    result = Todo.Server.handle_call({:entries, key, value}, nil, {list_name, [list, list2]})

    assert ^result = {:reply, [list], {list_name, [list, list2]}, :timer.seconds(30)}
  end

  test "entries/1" do
    list = %{"key" => "value"}
    list2 = %{"key2" => "value2"}
    list_name = "name"

    result = Todo.Server.handle_call({:entries}, nil, {list_name, [list, list2]})

    assert ^result = {:reply, [list, list2], {list_name, [list, list2]}, :timer.seconds(30)}
  end
end
