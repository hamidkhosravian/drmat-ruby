class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_one :attachments, as: :attachable
  has_one :images, as: :imageable

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
