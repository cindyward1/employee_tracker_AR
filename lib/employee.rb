class Employee < ActiveRecord::Base
    has_many :employees_projects
    has_many :projects, through: :employees_projects
    belongs_to :division
    validates :name, presence: true
    validates :name, uniqueness: true
end
