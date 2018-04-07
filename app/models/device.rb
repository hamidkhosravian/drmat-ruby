class Device < ApplicationRecord
  belongs_to :user
  has_many :auth_tokens

  validates :uuid, uniqueness: true
  validates :name, presence: true
  validates :os, presence: true
  validates :agent, presence: true

  enum os: %i[android ios windows linux mac_os]
  enum agent: %i[android_app, ios_app, web_app]
end
