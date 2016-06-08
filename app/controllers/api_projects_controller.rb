class ApiProjectsController < APIControllerBase

    VISIBLE_FIELDS = [:id, :name]

    def index 
        @projects = Project.all
        render json: @projects, only: VISIBLE_FIELDS, status: :ok
    end

    def show
        @project = Project.find(params[:project_id])
        render json: @project, only: VISIBLE_FIELDS, status: :ok
    end

    def create

    end

end