defmodule Todo.Server do
  use GenServer

  def start(name, db_module \\ Todo.Database) do
    GenServer.start(__MODULE__, {name, db_module})
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  @impl GenServer
  def init({name, db_module}) do
    # db read will block cache process.
    # could send self message and init in handle_info callback
    # works since process isnt registered, and pid won't return until after msg is sent
    list = if db_module, do: db_module.get(name)
    {:ok, {name, list || Todo.List.new()}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)

    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, date),
      {name, todo_list}
    }
  end
end
