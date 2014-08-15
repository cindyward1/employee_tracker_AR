require 'active_record'

require './lib/employee.rb'
require './lib/division.rb'

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
    puts "\nEnter 'e' for the employee menu, 'd' for the division menu"
    puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
    user_choice = gets.chomp

    case user_choice
    when 'e'
      employee_menu
    when 'd'
      division_menu
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

  puts "\nEnter 'a' to add an employee, 'v' to view all employees"
  puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_employee
  when 'v'
    view_employees
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
  Employee.all.each do |employee|
    puts "#{employee.id}. #{employee.name}"
  end
  puts "\n"
end

def division_menu

  puts "\nEnter 'a' to add a division, 'v' to view all divisions"
  puts "Enter 'm' to return to the main menu, and 'x' to exit the program\n"
  user_choice = gets.chomp

  case user_choice
  when 'a'
    add_division
  when 'v'
    view_divisions
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
  Division.all.each do |division|
    puts "#{division.id}. #{division.name}"
  end
  puts "\n"
end

welcome
