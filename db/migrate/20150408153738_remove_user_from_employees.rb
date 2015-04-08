class RemoveUserFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :user_id
  end
end
