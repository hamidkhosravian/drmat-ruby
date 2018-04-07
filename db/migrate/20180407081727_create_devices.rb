class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :uuid
      t.string :name
      t.integer :os
      t.integer :agent
      t.inet :device_last_ip
      t.inet :device_current_ip
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
