class CreateJoinTableEmployeesProjects < ActiveRecord::Migration
  def change
    create_table :employees_projects, id: false do  |t|
      t.belongs_to :employees
      t.belongs_to :projects
    end
    remove_column :projects, :employee_id
  end
end
