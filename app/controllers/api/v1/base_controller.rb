class Api::V1::BaseController < ActionController::Base

    before_action :authenticate

    # Handle errors.
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    rescue_from ActionController::UnpermittedParameters, with: :render_bad_request
    rescue_from ArgumentError, with: :render_bad_request

    def routing_error
        render_not_found
    end

    private
        def authenticate
            authenticate_token || render_unauthorized
        end

        def authenticate_token
            authenticate_with_http_token do |token, options|
                @user = APIUser.where(api_token: token)
                @user.present?
            end
        end

        # Return 404 if resource not found.
        def render_not_found
            render nothing: true, status: :not_found
        end

        # Return 400 if request was incorrectly formatted.
        def render_bad_request
            render nothing: true, status: :bad_request
        end

        # Return 401 if request is unauthorized.
        def render_unauthorized
            self.headers['WWW-Authenticate'] = "Token realm='Projects API'"
            render json: "401: API token required.", status: :unauthorized
        end
end
