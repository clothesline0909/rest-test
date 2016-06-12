module AuthenticationHelper
	def set_auth_token
		user = APIUser.create
        request.env['HTTP_AUTHORIZATION'] = "Token token=#{user.api_token}"
	end
end