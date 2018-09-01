defmodule Todo.TodoList do
  use Ecto.Schema
  import Ecto.Changeset


  schema "todo_list" do
    field :list, :map

    timestamps()
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:list])
    |> validate_required([:list])
  end
end
