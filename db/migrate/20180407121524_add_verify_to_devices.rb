class AddVerifyToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :verify, :string
    add_column :devices, :verify_sent_at, :datetime
  end
end
