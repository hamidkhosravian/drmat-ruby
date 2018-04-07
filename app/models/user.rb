class User < ApplicationRecord
  has_many :devices

  validates :phone, presence: true, uniqueness: true
  validates :role, presence: true

  enum role: %i[client expert doctor]

  before_validation :generate_uuid

  private

  def generate_random_hex(n = 1, predicate = proc {})
    hex = SecureRandom.uuid
    hex = SecureRandom.uuid while predicate.call(hex)
    hex
  end

  def generate_uuid
    self.uuid = generate_random_hex(6, ->(hex) { User.exists?(uuid: hex) }) if new_record?
  end
end
