class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :list, -> (user) do
    where('(conversations.sender_id = ? OR conversations.recipient_id = ?)', user.id, user.id)
  end

  def opposed_user(user)
    user == recipient ? sender : recipient
  end
end
