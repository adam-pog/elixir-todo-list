defmodule Todo.Cache do
  require Logger
  # API
  def start_link do
    Logger.info "Starting to-do cache."

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def server_process(todo_list_name) do
    existing_process(todo_list_name) || new_process(todo_list_name)
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  defp existing_process(todo_list_name) do
    Todo.Server.whereis(todo_list_name)
  end

  def new_process(todo_list_name) do
    case start_child(todo_list_name) do
      {:ok, pid} ->
        Logger.info "Started to-do server #{todo_list_name}"
        pid

      {:error, {:already_started, pid}} ->
        pid
    end
  end

  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Todo.Server, todo_list_name}
    )
  end
end
