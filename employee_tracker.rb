require 'active_record'

require './lib/employee.rb'
require './lib/division.rb'
require './lib/project.rb'
require './lib/employee_project.rb'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "\n\n"
  puts "*" * 32
  puts "Welcome to the Employee Tracker!"
  puts "*" * 32
  puts "\n"
  main_menu
end

def main_menu
  user_choice = nil
  until user_choice == 'x'
    puts "\nEnter 'e' for the employee menu, 'd' for the division menu,"
    puts "   or 'p' for the project menu"
    puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
    user_choice = gets.chomp

    case user_choice
    when 'e'
      employee_menu
    when 'd'
      division_menu
    when 'p'
      project_menu
    when 'm'
      # nothing
    when 'x'
      puts "Have a good one!"
    else
      puts "Invalid option, please try again"
    end
  end
end

def employee_menu

  puts "\nEnter 'a' to add an employee, 'v' to view all employees,"
  puts "      'd' to assign an employee to a division"
  puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_employee
  when 'v'
    view_employees
  when 'd'
    assign_employee_to_division
  when 'm'
    # nothing
  when 'x'
    puts "Have a good one!"
  else
    puts "Invalid option, please try again"
  end
end

def add_employee
  puts "\n\nEnter the employee's name:"
  employee_name = gets.chomp
  employee = Employee.new({:name => employee_name, :division_id => 0})
  employee.save
  puts "'#{employee_name}' has been successfully added."
end

def view_employees
  puts "\n\nHere's a list of all of the employees:"
  Employee.all.order(:division_id, :id).each do |employee|
    if employee.division_id != 0
      puts "#{employee.id}. #{employee.name}, Division = #{employee.division.name}"
    else
      puts "#{employee.id}. #{employee.name}, Division = Not yet assigned"
    end
  end
  puts "\n"
end

def assign_employee_to_division
  view_employees
  puts "\nSelect the index of the employee that you wish to assign to a division"
  the_employee_id = gets.chomp.to_i
  the_employee = Employee.where({:id=>the_employee_id}).first
  if the_employee.division_id == 0
    view_divisions
  puts "\nSelect the index of the division where you wish to assign the employee"
    the_division_id = gets.chomp.to_i
    the_employee.update({:division_id=>the_division_id})
    the_division = Division.where({:id=>the_division_id}).first
    puts "\nProject #{the_employee.name} has been assigned to #{the_division.name}\n"
  else
    the_division = Division.where({:id=>the_employee.division_id}).first
    puts "\nThat employee has already been assigned to #{the_division.name}\n"
  end
end

def division_menu

  puts "\nEnter 'a' to add a division, 'v' to view all divisions,"
  puts "   or 'e' to list all employees in a division"
  puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_division
  when 'v'
    view_divisions
  when 'e'
    view_employees_in_division
  when 'm'
    # nothing
  when 'x'
    puts "Have a good one!"
  else
    puts "Invalid option, please try again"
  end
end

def add_division
  puts "\n\nEnter the division's name:"
  division_name = gets.chomp
  division = Division.new({:name => division_name})
  division.save
  puts "'#{division_name}' has been successfully added."
end

def view_divisions
  puts "\n\nHere's a list of all of the divisions:"
  Division.all.order(:id).each do |division|
    puts "#{division.id}. #{division.name}"
  end
  puts "\n"
end

def view_employees_in_division
  view_divisions
  puts "Select the index of the division whose employees you wish to see"
  the_division_id = gets.chomp.to_i
  the_division = Division.where({:id=>the_division_id}).first
  the_employee_array = Employee.where({:division_id=>the_division.id}).order(:id)
  if the_employee_array.length > 0
    puts "\nFor division #{the_division.name}, the employees are:"
    the_employee_array.each do |the_employee|
      puts "#{the_employee.id}. #{the_employee.name}"
    end
  else
    puts "The division #{the_division.name} has no employees"
  end
  puts "\n"
end

def view_projects_in_division
end

def project_menu

  puts "\nEnter 'a' to add an project, 'v' to view all projects, or"
  puts "     'e to assign a project to an employee, or c to mark a project as complete, or"
  puts "     'w' to see what employees are working on a project"
  puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_project
  when 'v'
    view_projects
  when 'e'
    assign_project_to_employee
  when 'c'
    mark_project_as_completed
  when 'w'
    project_who_working
  when 'm'
    # nothing
  when 'x'
    puts "Have a good one!"
  else
    puts "Invalid option, please try again"
  end
end

def add_project
  puts "\n\nEnter the project's name:"
  project_name = gets.chomp
  project = Project.new({:name => project_name, :done=>false})
  project.save
  puts "'#{project_name}' has been successfully added."
end

def view_projects
  puts "\n\nHere's a list of all of the projects:"
  Project.all.order(:done, :id).each do |project|
    puts "#{project.id}. #{project.name}; done = #{project.done}"
  end
  puts "\n"
end

def assign_project_to_employee
  view_projects
  puts "\nSelect the index of the project that you wish to assign to an employee"
  the_project_id = gets.chomp.to_i
  the_project = Project.where({:id=>the_project_id}).first
  view_employees
  puts "\nSelect the index of the employee to whom you wish to assign the project"
  the_employee_id = gets.chomp.to_i
  the_employee = Employee.where({:id=>the_employee_id}).first
  puts "\nDescribe the employee's contribution to the project"
  the_contribution = gets.chomp
  the_table_entry = the_project.employees_projects.create({:employee_id=>the_employee.id,
                                                           :contribution=>the_contribution})
  puts "\nProject #{the_project.name} has been assigned to #{the_employee.name}\n"
  puts "   Their contribution is #{the_contribution}"
end

def mark_project_as_completed
  view_projects
  puts "\nSelect the index of the project that you wish to mark as completed"
  the_project_id = gets.chomp.to_i
  the_project = Project.where({:id=>the_project_id}).first
  if the_project.done == false
    the_project.update({:done=>true})
    puts "\nProject #{the_project.name} has been marked as completed\n"
  else
    puts "\nThat project has already been marked as completed\n"
  end
end

def project_who_working
  view_projects
  puts "\nSelect the index of the project for which you wish to see the employees"
  the_project_id = gets.chomp.to_i
  the_project = Project.where({:id=>the_project_id}).first
  p the_project.employees_projects
  puts "\nFor project #{the_project.name}, the employees are"
  the_project.employees_projects.each do |employee_project|
    p employee_project.employees
    puts "#{employee_project.id}. #{employee_project.employees.name}, #{employee_project.contribution}"
  end
end

welcome
