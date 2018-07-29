defmodule Todo.DatabaseMock do
  def start_link do

  end

  def store(_, _) do
    nil
  end

  def get(_) do
    nil
  end
end
