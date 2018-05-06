class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :phone
      t.integer :role, default: 0

      t.timestamps
    end
    add_index :users, :phone, unique: true
  end
end
