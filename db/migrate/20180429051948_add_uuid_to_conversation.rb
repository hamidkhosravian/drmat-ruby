class AddUuidToConversation < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :uuid, :string
  end
end
