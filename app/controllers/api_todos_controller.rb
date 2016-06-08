class ApiTodosController < APIControllerBase

	VISIBLE_FIELDS = [:id, :name, :project_id]

	def index
		@todos = Todo.where(project_id: params[:project_id])
		render json: @todos, only: VISIBLE_FIELDS, status: :ok
	end

	def show
		@todo = Todo.where(project_id: params[:project_id], id: params[:todo_id])
		if @todo.length != 0
			render json: @todo, only: VISIBLE_FIELDS, status: :ok
		else
			render_not_found
		end
	end
end