defmodule Todo.Database do
  require Logger

  @pool_size 3
  @db_folder "./elixir_persist"

  def store(key, data) do
    {_results, bad_nodes} =
      :rpc.multicall(
        __MODULE__,
        :store_local,
        [key, data],
        :timer.seconds(5)
      )

    Enum.each(bad_nodes, &Logger.info "Store failed on node #{&1}")
    :ok
  end

  def store_local(key, data) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.store(worker_pid, key, data)
      end
    )
  end

  def get(key) do
    :poolboy.transaction(
      __MODULE__,
      fn worker_pid ->
        Todo.DatabaseWorker.get(worker_pid, key)
      end
    )
  end

  def child_spec(_) do
    [node_prefix, _] = "#{node()}" |> String.split("@")
    folder = "#{@db_folder}/#{node_prefix}"
    File.mkdir_p!(folder)

    :poolboy.child_spec(
      __MODULE__,
      [
        name: {:local, __MODULE__},
        worker_module: Todo.DatabaseWorker,
        size: @pool_size
      ],
      [folder]
    )
  end
end
