defmodule TodoCacheTest do
  use ExUnit.Case

  describe "server_process" do
    test "caches servers" do
      Todo.Cache.start_link(nil)
      bob_pid = Todo.Cache.server_process("bob")

      assert bob_pid == Todo.Cache.server_process("bob")
    end

    test "returns new server for different name" do
      Todo.Cache.start_link(nil)
      bob_pid = Todo.Cache.server_process("bob")

      assert bob_pid != Todo.Cache.server_process("alice")
    end
  end
end
