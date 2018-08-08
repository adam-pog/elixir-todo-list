defmodule EtsRegistry do
  use GenServer

  # api

  def start do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    Process.link(Process.whereis(__MODULE__))
    case :ets.insert_new(__MODULE__, {name, self()}) do
      true -> :ok
      false -> :error
    end
  end

  def whereis(name) do
    case :ets.lookup(__MODULE__, name) do
      [{^name, pid}] -> pid
      _ -> nil
    end
  end

  # server

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(__MODULE__, [:named_table, :public, read_concurrency: true, write_concurrency: true])
    {:ok, nil}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _}, _) do
    IO.puts("Removing all names associated with #{inspect(pid)}")
    :ets.match_delete(__MODULE__, {:_, pid})

    {:noreply, nil}
  end

  @impl GenServer
  def handle_info(unknown_message, state) do
    super(unknown_message, state)
  end
end
