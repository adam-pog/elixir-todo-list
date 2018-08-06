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
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

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

  def handle_call({:whereis, name}, _, store) do
    case Map.fetch(store, name) do
      :error ->
        {:reply, nil, store}

      value ->
        {:reply, value, store}
    end
  end
end
