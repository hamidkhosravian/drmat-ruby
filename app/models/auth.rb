# authentication common functions
module Auth
  # return first association auth_token model
  def token
    auth_tokens.newer.first
  end

  # generate and asign token and refresh token to Model with AuthToken Model
  # Class.generate_auth_token '127.0.0.1'
  # Class.auth_tokens.token # => eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJhdXRoX3R
  # Class.auth_tokens.refresh_token # => ab9239a532e59a164e1e9a319d5c
  # ttl = ENV['AUTH_TOKEN_TTL'].to_i
  def generate_auth_token(ttl = ENV['AUTH_TOKEN_TTL'], refresh_ttl = ENV['REFRESH_TOKEN_TTL'], socket_ttl = ENV['SOCKET_TOKEN_TTL'])
    ttl = ttl.to_i.hour.from_now
    socket_ttl = ttl.to_i.hour.from_now
    refresh_ttl = refresh_ttl.to_i.hour.from_now

    auth_token = auth_tokens.build

    auth_token.token = ::AuthTokenService.encode({ uuid: uuid, os: os, name: name }, ttl)
    auth_token.token_expires_at = ttl

    auth_token.refresh_token = generate_refresh_token
    auth_token.refresh_token_expires_at = refresh_ttl

    auth_token.socket_token = ::AuthTokenService.encode({ uuid: uuid, os: os }, socket_ttl)
    auth_token.socket_token_expires_at = refresh_ttl
  end

  # invalidate current token and refresh token in 1 minute
  def invalidate_auth_token
    exp = Time.now
    return false if auth_tokens.empty?
    auth_token = token

    auth_token.token = ::AuthTokenService.encode({ uuid: uuid }, exp)
    auth_token.token_expires_at = 1.days.ago
    auth_token.refresh_token = 1.days.ago
    auth_token.refresh_token_expires_at = 1.days.ago
    auth_token.socket_token = 1.days.ago
    auth_token.socket_token_expires_at = 1.days.ago
    auth_token.save!
  end

  def update_tracked_fields(env)
    user.verify_sent_at = 1.days.ago
    user.save!
  end

  private

  # generate random string for refresh token
  def generate_refresh_token
    Digest::MD5.hexdigest(Time.now.to_s) + SecureRandom.hex
  end
end
