class AddTodoDateToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :todo_date, :date
  end
end
