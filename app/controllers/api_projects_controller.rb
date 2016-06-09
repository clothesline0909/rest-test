class ApiProjectsController < ApiBaseController

    VISIBLE_FIELDS = [:id, :name]

    def index 
        start = params[:start_date].to_time
        finish = params[:end_date].to_time
        query_params = {
            name: params[:name],
            created_at: start..finish
        }
        @projects = Project.where(query_params)
        render json: @projects, only: VISIBLE_FIELDS, status: :ok
    end

    def show
        @project = Project.find(params[:project_id])
        render json: @project, only: VISIBLE_FIELDS, status: :ok
    end

    def create
        @project = Project.new(project_params)
        @existing_project = Project.find_by_name(params[:project][:name])
        if @existing_project.present?
            render nothing: true, status: :conflict
        elsif @project.save
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