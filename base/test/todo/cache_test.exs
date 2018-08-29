defmodule TodoCacheTest do
  use ExUnit.Case

  describe "server_process" do
    test "caches servers" do
      bob_pid = Todo.Cache.server_process("bob")

      assert bob_pid == Todo.Cache.server_process("bob")
    end

    test "returns new server for different name" do
      bob_pid = Todo.Cache.server_process("bob")

      assert bob_pid != Todo.Cache.server_process("alice")
    end
  end
end
