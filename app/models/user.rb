class User < ApplicationRecord
  has_many :devices

  validates :uuid, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :role, presence: true

  enum role: %i[client expert doctor]
end
