class AddPolymorphicAssociationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_id, :integer
    add_column :users, :role_type, :string
    remove_column :users, :role

    add_index :users, [:role_id, :role_type]
  end
end
