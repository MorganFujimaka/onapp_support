class AddRoleToUser < ActiveRecord::Migration
  def up
    add_column :users, :role, :string, default: 'customer'
  end

  def down
    remove_column :users, :role
  end
end
