class User < ApplicationRecord
  has_one :profile
  has_many :devices
  has_many :messages
  has_many :start_conversations, foreign_key: :sender_id, class_name: 'Conversation'
  has_many :listen_conversations, foreign_key: :recipient_id, class_name: 'Conversation'

  validates :phone, presence: true, uniqueness: true
  validates :role, presence: true

  enum role: %i[client expert doctor admin]

  before_validation :generate_uuid
  after_create :create_profile

  private

  def generate_random_hex(n = 1, predicate = proc {})
    hex = SecureRandom.uuid
    hex = SecureRandom.uuid while predicate.call(hex)
    hex
  end

  def generate_uuid
    self.uuid = generate_random_hex(6, ->(hex) { User.exists?(uuid: hex) }) if new_record?
  end

  def create_profile
    Profile.create!(user: self, first_name: nil, last_name: nil, birthday: nil)
  end
end
