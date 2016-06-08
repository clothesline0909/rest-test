class ApiProjectsController < BaseAPIController
    before_filter :find_project, only: [:show, :update]

    before_filter only: :create do
        unless @json.has_key?('project') and @json['project'].responds_to?(:[]) and @json['project']['name']
            render nothing: true, status: :bad_request
        end
    end

    before_filter only: :update do
        unless @json.has_key?('project')
            render nothing: true, status: :bad_request
        end
    end

    def index 
        render json: Project.all
    end

    def show
        render json: @project
    end

    def create

    end

    private
        def find_project
            @project = Project.find_by_name(params[:name])
            render nothing: true, status: :not_found unless @project.present?
        end
end