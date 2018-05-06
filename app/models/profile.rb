class Profile < ApplicationRecord
  belongs_to :user
  validates :first_name, presence: true, allow_blank: true
  validates :last_name, presence: true, allow_blank: true
  validates :birthday, presence: true, allow_blank: true

  has_one :image, as: :imageable
end
