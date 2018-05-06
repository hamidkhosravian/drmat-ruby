class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.integer :imageable_id
      t.belongs_to :imageable, polymorphic: true

      t.timestamps
    end
    add_index :images, [:imageable_id, :imageable_type]
  end
end
