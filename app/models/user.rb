class User < ApplicationRecord
  validates :phone, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true

  enum role: %i[client expert doctor]

end
