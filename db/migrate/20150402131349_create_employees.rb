class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :department

      t.timestamps null: false
    end
  end
end
