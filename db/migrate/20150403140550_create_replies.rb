class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :ticket, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
