class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :list, lambda { |user|
    where('(conversations.sender_id = ? OR conversations.recipient_id = ?)', user.id, user.id)
  }

  def opposed_user(user)
    user == recipient ? sender : recipient
  end

  before_validation :generate_uuid

  after_create_commit { ConversationBroadcastJob.perform_later(self) }

  private
    def generate_random_hex(n = 1, predicate = proc {})
      hex = SecureRandom.hex(n)
      hex = SecureRandom.hex(n) while predicate.call(hex)
      hex
    end

    def generate_uuid
      self.uuid = generate_random_hex(12, ->(hex) { Conversation.exists?(uuid: hex) }) if new_record?
    end
end
