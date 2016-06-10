class APIUser < ActiveRecord::Base

    before_validation do |user| 
        user.api_token = generate_api_token
    end

    validates :api_token,
        presence: true,
        length: {
            minimum: 8,
            maximum: 50
        },
        uniqueness: true

    private
        def generate_api_token
            loop do
                token = SecureRandom.base64.tr("+/=", "GsD")
                break token unless APIUser.exists?(api_token: token)
            end
        end
end