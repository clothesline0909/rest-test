class Todo < ActiveRecord::Base

    belongs_to :project

    validates :name,
        presence: true,
        length: {
            minimum: 3,
            maximum: 50
        }

    before_save {
        self.name = name.downcase
    }
end