class AddNameAndDivisionToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :name, :string
    add_column :employees, :division_id, :integer

    add_timestamps :employees
  end
end
