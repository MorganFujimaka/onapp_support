class AddUserToReplies < ActiveRecord::Migration
  def up
    add_column :replies, :user_id, :integer
  end

  def down
    remove_column :replies, :user_id
  end
end
