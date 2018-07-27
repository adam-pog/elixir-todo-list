defmodule TodoDatabaseTest do
  use ExUnit.Case

  describe "it returns the same worker for the same key" do
    test "choose_worker callback" do
      worker_pids = %{0 => :worker1, 1 => :worker2, 2 => :worker3}
        worker1 = Todo.Database.handle_call({:choose_worker, "key1"}, nil, worker_pids)
        worker2 = Todo.Database.handle_call({:choose_worker, "key1"}, nil, worker_pids)

        assert worker1 == worker2
    end
  end

  describe "it returns different workers for different keys" do
    test "choose_worker callback" do
      worker_pids = %{0 => :worker1, 1 => :worker2, 2 => :worker3}
        worker1 = Todo.Database.handle_call({:choose_worker, "key1"}, nil, worker_pids)
        worker2 = Todo.Database.handle_call({:choose_worker, "key2"}, nil, worker_pids)
        worker3 = Todo.Database.handle_call({:choose_worker, "key3"}, nil, worker_pids)

        assert worker1 != worker2
        assert worker2 != worker3
    end
  end
end
