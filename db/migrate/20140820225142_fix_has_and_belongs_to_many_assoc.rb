class FixHasAndBelongsToManyAssoc < ActiveRecord::Migration
  def change
    remove_column :employees_projects, :projects_id
    remove_column :employees_projects, :employees_id
    add_column :employees_projects, :employee_id, :integer
    add_column :employees_projects, :project_id, :integer
  end
end
