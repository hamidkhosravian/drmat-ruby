class AddVerifyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :verify, :string
    add_column :users, :verify_sent_at, :datetime
  end
end
