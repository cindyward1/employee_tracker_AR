class AddContributionField < ActiveRecord::Migration
  def change
    add_column :employees_projects, :contribution, :string
  end
end
