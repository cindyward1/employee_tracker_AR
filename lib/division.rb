class Division < ActiveRecord::Base
  has_many :employees
  validates :name, presence: true
  validates :name, uniqueness: true
end
