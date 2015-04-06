class AddAasmToTickets < ActiveRecord::Migration
  def up
    add_column :tickets, :aasm_state, :string
    remove_column :tickets, :status

    add_index :tickets, :aasm_state
  end

  def down
    remove_column :tickets, :aasm_state
    add_column :tickets, :status, :string, default: "waiting_for_staff", null: false
  end
end
