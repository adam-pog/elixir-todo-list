defmodule Todo.Metrics do
  require Logger

  use Task

  def start_link(_arg), do: Task.start_link(&loop/0)

  defp loop() do
    # Process.sleep(:timer.seconds(10))
    Logger.info(inspect collect_metrics())
    # loop()
  end

  defp collect_metrics() do
    [
      memory_usage: :erlang.memory(:total),
      process_count: :erlang.system_info(:process_count)
    ]
  end
end
