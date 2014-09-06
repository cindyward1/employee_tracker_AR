class EmployeesProject < ActiveRecord::Base
    belongs_to :employees
    belongs_to :projects
    validates :contribution, presence: true
end
