defmodule Todo.Server do
  use Agent, restart: :temporary

  @db_module Application.get_env(:todo, :db_module)

  def start_link(name) do
    Agent.start_link(
      fn ->
        IO.puts("Starting to-do server.")
        {name, @db_module.get(name) || Todo.List.new()}
      end,
      name: via_tuple(name)
    )
  end

  def add_entry(todo_server, new_entry) do
    Agent.cast(todo_server, fn {name, todo_list} ->
      new_list = Todo.List.add_entry(todo_list, new_entry)
      @db_module.store(name, new_list)
      {name, new_list}
    end)
  end

  def entries(todo_server, date) do
    Agent.get(todo_server, fn({name, todo_list}) ->
      Todo.List.entries(todo_list, date)
    end)
  end

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
