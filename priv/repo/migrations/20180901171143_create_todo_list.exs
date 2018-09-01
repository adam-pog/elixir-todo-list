defmodule Todo.Repo.Migrations.CreateTodoList do
  use Ecto.Migration

  def change do
    create table(:todo_list) do
      add :list, :map

      timestamps()
    end

  end
end
