class AuthToken < ApplicationRecord
  belongs_to :device

  validates :token, length: { minimum: 20 }, uniqueness: true
  validates :refresh_token, length: { minimum: 20 }, uniqueness: true
  validates :socket_token, length: { minimum: 20 }, uniqueness: true
  validates_datetime :token_expires_at, after: -> { DateTime.now }, on: [:create]
  validates_datetime :socket_token_expires_at, after: -> { DateTime.now }, on: [:create]
end
