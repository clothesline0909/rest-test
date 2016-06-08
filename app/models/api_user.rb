class APIUser < ActiveRecord::Base

    validates :api_token,
        presence: true,
        length: {
            minimum: 8,
            maximum: 50
        },
        uniqueness: true
end