require 'auth_token_service'

# authentication Service
# use JWT
class AuthService
  attr_reader :request
  attr_reader :auth_token

  # constructor of class
  # @param request [Request]
  def initialize(request)
    @request = request
    @auth_token = request.headers['Authorization']
  end

  # check user token
  def authenticate_user!
    raise AuthError unless valid_to_proceed?
    @device = ::Device.find_by(uuid: decoded_auth_token[:uuid])
  end

  # destory user token
  def destroy_session!
    raise AuthError unless valid_to_logout?
    decoded_auth_token[:uuid]
  end

  private

  # check user has access or not to logout
  def valid_to_logout?
    http_auth_token && decoded_auth_token && decoded_auth_token[:uuid] && valid_token?
  end

  # check user has access or not for a request
  def valid_to_proceed?
    http_auth_token && decoded_auth_token && decoded_auth_token[:uuid] && valid_token? # && valid_device?
  end

  # check user token and validation of token
  def valid_token?
    device = ::Device.find_by(uuid: decoded_auth_token[:uuid])
    token.token == http_auth_token if device
  end

  def valid_device?
    user_agent = UserAgent.parse @request.user_agent
    if user_agent.first.comment.to_s.downcase.include? 'android'
      os = 0
    elsif user_agent.first.comment.to_s.downcase.include? 'ios'
      os = 1
    elsif user_agent.first.comment.to_s.downcase.include? 'windows'
      os = 2
    elsif user_agent.first.comment.to_s.downcase.include? 'linux'
      os = 3
    elsif user_agent.first.comment.to_s.downcase.include? 'os' || 'macintosh'
      os = 4
    end

    uuid = @params.try(:[], 'device').try(:[], 'uid') || @request.session.id
    name = @params.try(:[], 'device').try(:[], 'name') || user_agent.browser
    device = ::Device.find_by(uuid: decoded_auth_token[:uuid])
    device.os == os && device.name == name && device.uuid == uuid
  end

  # decode the token and return the response
  def decoded_auth_token
    @decoded_auth_token ||= ::AuthTokenService.decode(http_auth_token)
  end

  # get token from Authorization in header
  def http_auth_token
    if auth_token.to_s.split(' ').first.casecmp('bearer').zero?
      @http_auth_token ||= auth_token.split(' ').last
    elsif Rails.env.development? && auth_token.split(' ').first.casecmp('basic').zero?
      @http_auth_token = Base64.decode64(auth_token.split(' ').last)
    end
  end
end
