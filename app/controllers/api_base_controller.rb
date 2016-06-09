class ApiBaseController < ApplicationController

    # Handle errors.
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    rescue_from ActionController::UnpermittedParameters, with: :render_bad_request

    def routing_error
        render_not_found
    end

    private
        def authenticate_user_from_token!
            if !@json['api_token']
                render nothing: true, status: :unauthorized
            else
                @user = nil
                APIUser.find_each do |u|
                    if Devise.secure_compare(u.api_token, @json['api_token'])
                        @user = u
                    end
                end
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
end