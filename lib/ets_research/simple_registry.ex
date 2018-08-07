defmodule SimpleRegistry do
  use GenServer

  # api
  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whereis, name})
  end

  # server

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, name}, {caller, _}, store) do
    case Map.fetch(store, name) do
      :error ->
        Process.link(caller)
        new_state = Map.put(store, name, caller)
        {:reply, :ok, new_state}

      _ ->
        {:reply, :error, store}
    end
  end

  @impl GenServer
  def handle_call({:whereis, name}, _, store) do
    case Map.fetch(store, name) do
      :error ->
        {:reply, nil, store}

      value ->
        {:reply, value, store}
    end
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _}, store) do
    IO.puts("Removing all names associated with #{inspect(pid)}")
    new_store = for {key, value} <- store, value != pid, into: %{}, do: {key, value}

    {:noreply, new_store}
  end

  @impl GenServer
  def handle_info(unknown_message, state) do
    super(unknown_message, state)
    {:noreply, state, @expiry_idle_timeout}
  end
end
