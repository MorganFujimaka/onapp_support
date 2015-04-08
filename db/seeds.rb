%w(Business Information Finance PR Legacy).each do |department|
  Department.where(name: department).first_or_create
end

5.times do |n|
  employee = Employee.where(department: Department.all[n]).first_or_create!
 
  employee.create_user do |user|
    user.password = '12345678'
    user.username = "employee_#{n + 1}" 
    user.email = "employee_#{n + 1}@gmail.com"
  end unless employee.user
end

Ticket.aasm.states.map(&:name).each do |state|
  Ticket.where(customer_name: 'Morgan', customer_email: 'morgan.fujimaka@gmail.com',
               subject: "#{state.capitalize} ticket", department: Department.all[rand(5)], aasm_state: state,
               body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.').first_or_create
end
