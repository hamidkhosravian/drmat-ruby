class Device < ApplicationRecord
  include Auth

  belongs_to :user
  has_many :auth_tokens, autosave: true

  validates :uuid, uniqueness: true
  validates :name, presence: true
  validates :os, presence: true
  validates :agent, presence: true

  enum os: %i[android ios windows linux mac_os]
  enum agent: %i[android_app, ios_app, web_app]

  before_validation :generate_uuid

  private

  def generate_random_hex(n = 1, predicate = proc {})
    hex = SecureRandom.uuid
    hex = SecureRandom.uuid while predicate.call(hex)
    hex
  end

  def generate_uuid
    self.uuid = generate_random_hex(6, ->(hex) { Device.exists?(uuid: hex) }) if new_record?
  end
end
