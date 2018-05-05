class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_one :attachment, as: :attachable
  has_one :image, as: :imageable

end
