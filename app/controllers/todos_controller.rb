class TodosController < ApplicationController
  def index
    @todo_items=Todo.all
    if(params[:id])
      @new_todo = Todo.find(params[:id])
      @nombre = "Save"
      @type = "Modify"
    else
      @new_todo = Todo.new
      @nombre = "Create"
      @type = "Insert"
    end
  end

  def create 
    if params[:back]
      redirect_to index_path
    else
      if params[:todo][:id].to_i>0
        t = Todo.find(params[:todo][:id])
        t.update_attribute(:todo_item, params[:todo][:todo_item])
        t.update_attribute(:todo_date, params[:todo][:todo_date])
        flash[:success] = "Item saved"
        redirect_to index_path
      else
      	todo = Todo.create(:todo_item => params[:todo][:todo_item],:todo_date => params[:todo][:todo_date],:completed => false)
      	todo.save
      	if !todo.valid?
      		flash[:error] = todo.errors.full_messages.join("<br>").html_safe
      	else
      		flash[:success] = "Added to list"
    	  end
    	  redirect_to index_path
      end
    end
   end

   def complete
    if(params[:todos_checkbox])
      if params[:toggle]
        params[:todos_checkbox].each do |check|
          todo_id = check
          t = Todo.find_by_id(todo_id)
          if t.completed
            t.update_attribute(:completed, false)
          else
            t.update_attribute(:completed, true)
          end
        end
        flash[:success] = "Items toggled"
      else
        params[:todos_checkbox].each do |check|
          todo_id = check
          t = Todo.find_by_id(todo_id)
          t.destroy
        end
        flash[:success] = "Items deleted"
      end
    else
      if params[:toggle]
        flash[:warning] = "Must select one or more items to toggle"
      else
        flash[:warning] = "Must select one or more items to destroy"
      end
    end
    redirect_to :action => 'index'
   end

   def delete
      Todo.find(params[:id]).destroy
      redirect_to index_path
   end

   def edit
      redirect_to index_path(:id => params[:id])
   end
end
