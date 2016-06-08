class ApplicationController < ActionController::Base
	rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception

  	private
  		def render_not_found
  			render nothing: true, status: :not_found
  		end
end
