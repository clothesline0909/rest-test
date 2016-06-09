class Project < ActiveRecord::Base

    has_many :todos, dependent: :delete_all

    validates :name,
        presence: true,
        length: {
            minimum: 3,
            maximum: 50
        },
        uniqueness: {
            case_sensitive: false
        }

    before_save {
        self.name = name.downcase
    }
end