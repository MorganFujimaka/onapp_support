class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string     :uref, null: false
      t.string     :customer_name, null: false
      t.string     :customer_email, null: false
      t.string     :subject, null: false
      t.references :department
      t.references :employee
      t.text       :body, null: false
      t.string     :status, null: false, default: 'waiting_for_staff'

      t.timestamps null: false
    end

    add_index :tickets, :uref, unique: true
    add_index :tickets, :subject
  end
end
