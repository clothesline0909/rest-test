class Project < ActiveRecord::Base
    include Filterable

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

    # Scope query methods.
    scope :project_name, -> (name) { where("name like ?", "%#{name}%")}
    scope :start_date, -> (date) { where("created_at >= ?", "#{date.to_time}")}
    scope :end_date, -> (date) { where("created_at < ?", "#{date.to_time + 1.day}")} 
end