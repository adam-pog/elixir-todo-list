defmodule TodoCacheTest do
  use Todo.DataCase

  test "server_process" do
    cache = Todo.Cache.start_link()
    server1_pid = Todo.Cache.server_process("server_through_cache")

    assert Todo.Cache.server_process("server_through_cache") == server1_pid
    assert Todo.Cache.server_process("server2_through_cache") != server1_pid
  end
end
