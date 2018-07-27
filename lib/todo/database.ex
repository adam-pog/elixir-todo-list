defmodule Todo.Database do
  use GenServer

  @db_folder "./elixir_persist"

  def start do
    IO.puts("Starting to-do database.")
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, generate_worker_hash()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, worker_pids) do
    {:reply, worker_pids[:erlang.phash2(key, 3)], worker_pids}
  end

  defp generate_worker_hash do
    Enum.reduce(0..2, %{}, fn key, map ->
      {:ok, worker_pid} = start_worker()
      Map.put(map, key, worker_pid)
    end)
  end

  defp start_worker do
    Todo.DatabaseWorker.start(@db_folder)
  end
end
