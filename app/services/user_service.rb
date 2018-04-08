class UserService
  def access(params, request)
    user = User.find_or_create_by!(phone: params[:phone])
    user.update_attributes!(verify: SecureRandom.hex(3))

    base_url = "https://api.kavenegar.com/v1/#{ENV["KAVENEGAR_API_KEY"]}"
    conn = Faraday.new base_url
    response = conn.post do |req|
      req.url 'verify/lookup.json'
      req.params["receptor"] = user.phone
      req.params["token"] = user.verify
      req.params["template"] = "verification"
    end

    response = JSON.parse(response.body)
    raise ServerError, 'sorry we have a problem right now' unless response.try(:[], 'return').try(:[], 'status').to_i == 200
    user.update_attributes(verify_sent_at: Time.now)
    user
  end

  def authorize(params,  request)
    user = User.find_by(verify: params['verify'])
    raise AuthError, 'this token is not valid.' unless user || (user.verify_sent_at + ENV['VERIFY_TTL'] <= Time.now)
    device = DeviceService.new(params, request).create_or_find_device(user)
    DeviceService.new(params, request).create_token(device)
    device
  end
end
