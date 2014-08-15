require 'spec_helper'

describe Employee do
  it "has many employees" do
    test_division = Division.create({:name => 'Drinking Tea'})
    test_employee = Employee.create({:name => 'Cindy', :division_id => test_division.id})
    test_project1 = Project.create({:name => 'Wash teacups', :done => false,
                                    :employee_id => test_employee.id})
    test_project2 = Project.create({:name => 'Dry flowers', :done => false,
                                    :employee_id => test_employee.id})
    expect(test_employee.projects).to eq [test_project1, test_project2]
  end
end
