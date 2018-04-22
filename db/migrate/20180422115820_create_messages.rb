class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body, null: false, limit: 700
      t.references :user, foreign_key: true
      t.references :conversation, foreign_key: true

      t.timestamps
    end
  end
end
