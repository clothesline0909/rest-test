class Api::V1::TodosController < Api::V1::BaseController

    VISIBLE_FIELDS = [:id, :name, :project_id]

    def index
        @todos = Todo.where(project_id: params[:project_id])
        render json: @todos, only: VISIBLE_FIELDS, status: :ok
    end

    def show
        @todo = Todo.find(params[:todo_id])
        if @todo[:project_id] != params[:project_id].to_i
            render_not_found
        else
            render json: @todo, only: VISIBLE_FIELDS, status: :ok
        end
    end

    def create
        @todo = Todo.new(todo_params)
        @todo.project_id = params[:project_id]
        if @todo.save
            render json: @todo, only: VISIBLE_FIELDS, status: :created
        else
            render nothing: true, status: :bad_request
        end
    end

    def update
        @todo = Todo.find(params[:todo_id])
        if @todo[:project_id] != params[:project_id].to_i
            render_not_found
            return
        end
        @todo.assign_attributes(todo_params)
        if @todo.save
            render json: @todo, only: VISIBLE_FIELDS, status: :ok
        else
            render nothing: true, status: :bad_request
        end
    end

    def delete
        @todo = Todo.find(params[:todo_id])
        if @todo.project_id != params[:project_id].to_i
            render nothing: true, status: :not_found
        elsif @todo.destroy
            render nothing: true, status: :ok
        else
            render nothing: true, status: :bad_request
        end
    end

    private
        def todo_params
            params.require(:todo).permit(:name)
        end
end