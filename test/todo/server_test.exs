defmodule TodoServerTest do
  use ExUnit.Case

  test "add_entry" do
    {:ok, pid} = Todo.Server.start_link("name")
    date = ~D[2018-12-12]
    Todo.Server.add_entry(pid, %{date:  date, title: "title"})
    entries = Todo.Server.entries(pid, :date, date)

    assert [%{date: ^date, title: "title"}] = entries
  end
end