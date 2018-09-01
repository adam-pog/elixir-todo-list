defmodule Todo.TodoList do
  use Ecto.Schema
  import Ecto.Changeset


  schema "todo_list" do
    field :list, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:list, :name])
    |> validate_required([:list, :name])
  end

  def entries(todo_list, key, value) do
    todo_list
    |> Enum.filter(fn entry -> entry[key] == value end)
  end
end
