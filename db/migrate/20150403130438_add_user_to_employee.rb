class AddUserToEmployee < ActiveRecord::Migration
  def up
    add_column :employees, :user_id, :integer
  end

  def down
    remove_column :employees, :user_id
  end
end
