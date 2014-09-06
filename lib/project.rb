class Project < ActiveRecord::Base
  has_many :employees_projects
  has_many :employees, through: :employees_projects
  validates :name, presence: true
  validates :name, uniqueness: true
end
