class Api::V1::ProjectsController < Api::V1::BaseController

    VISIBLE_FIELDS = [:id, :name]
    ALLOWED_QUERY_KEYS = [:project_name, :start_date, :end_date]

    def index 
        @projects = Project.filter(params.slice(*ALLOWED_QUERY_KEYS))
        render json: @projects, only: VISIBLE_FIELDS, status: :ok
    end

    def show
        @project = Project.find(params[:project_id])
        render json: @project, only: VISIBLE_FIELDS, status: :ok
    end

    def create
        @project = Project.new(project_params)
        if @project.save
            render json: @project, only: VISIBLE_FIELDS, status: :created
        else
            render nothing: true, status: :bad_request
        end
    end

    def update
        @project = Project.find(params[:project_id])
        @project.assign_attributes(project_params)
        if @project.save
            render json: @project, only: VISIBLE_FIELDS, status: :ok
        else
            render nothing: true, status: :bad_request
        end
    end

    def delete
        @project = Project.find(params[:project_id])
        if @project.destroy
            render nothing: true, status: :ok
        else
            render nothing: true, status: :bad_request
        end
    end

    private
        def project_params
            params.require(:project).permit(:name)
        end
end