defmodule Todo.Server do
  require Logger

  use GenServer, restart: :temporary

  @db_module Application.get_env(:todo, :db_module)
  @expiry_idle_timeout :timer.seconds(30)

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: global_name(name))
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, key, value) do
    GenServer.call(todo_server, {:entries, key, value})
  end

  def whereis(name) do
    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end

  @impl GenServer
  def init(name) do
    # db read will block cache process.
    # could send self message and init in handle_info callback
    # works since process isnt registered, and pid won't return until after msg is sent
    {:ok, {name, @db_module.get(name) || Todo.List.new()}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    @db_module.store(name, new_list)

    {:noreply, {name, new_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_call({:entries, key, value}, _, {name, todo_list}) do
    {
      :reply,
      Todo.List.entries(todo_list, key, value),
      {name, todo_list},
      @expiry_idle_timeout
    }
  end

  @impl GenServer
  def handle_info(:timeout, {name, todo_list}) do
    Logger.info "Stopping to-do server for #{name}"
    {:stop, :normal, {name, todo_list}}
  end

  @impl GenServer
  def handle_info(unknown_message, state) do
    super(unknown_message, state)
    {:noreply, state, @expiry_idle_timeout}
  end

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end
end
