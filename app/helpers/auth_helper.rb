require 'auth_service'

module AuthHelper
  # generate a refresh token for user's device
  def refresh_user!(token, request)
    auth_token = AuthToken.find_by(refresh_token: token)
    # refresh token expires
    raise AuthError, I18n.t('messages.authentication.signin.refresh_token') if auth_token.nil? || auth_token.refresh_token_expires_at.nil? || auth_token.refresh_token_expires_at.to_date <= Time.now

    device = auth_token.tokenable
    create_token(device, request)
  end

  # invalidate all session
  def logout_user!
    device_id = ::AuthService.new(request).destroy_session!
    device = ::Device.includes(:auth_tokens).find_by_id(device_id)
    device.invalidate_auth_token
  end

  # authenticate current request
  def authenticate!
    @current_user = ::AuthService.new(request).authenticate_user!
  end

  # return current authenticated user
  def current_user
    @current_user
  end

  private
    # create new token for user
    # this method will invalidate last token
    def create_token(device, request)
      device.device_last_ip = device.device_current_ip
      device.device_current_ip = request.remote_ip
      device.updated_at = Time.now

      device.invalidate_auth_token
      device.generate_auth_token
      device.update_tracked_fields(request.env)
      device.save!
      device
    end
end
