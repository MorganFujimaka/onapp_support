class AddEmployeeToReply < ActiveRecord::Migration
  def change
    remove_column :replies, :user_id, :integer
    add_reference :replies, :employee, index: true
  end
end
