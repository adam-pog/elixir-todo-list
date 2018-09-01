defmodule Todo.Repo.Migrations.AddNameToTodoList do
  use Ecto.Migration

  def change do
    alter table(:todo_list) do
      add :name, :text, null: false
    end
  end
end
