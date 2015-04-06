module RepliesHelper
  def employees_names
    Employee.includes(:user).map { |e| [e.username, e.id] }
  end
end
