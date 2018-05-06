class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.belongs_to :attachable, polymorphic: true

      t.timestamps
    end
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
