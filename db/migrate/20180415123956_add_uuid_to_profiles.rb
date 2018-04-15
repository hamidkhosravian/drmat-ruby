class AddUuidToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :uuid, :string
  end
end
