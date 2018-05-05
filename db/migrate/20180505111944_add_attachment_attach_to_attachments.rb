class AddAttachmentAttachToAttachments < ActiveRecord::Migration[5.1]
  def self.up
    change_table :attachments do |t|
      t.attachment :attach
    end
  end

  def self.down
    remove_attachment :attachments, :attach
  end
end
