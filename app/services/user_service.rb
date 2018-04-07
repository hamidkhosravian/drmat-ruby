class UserService
  def access(params, request)
    user = User.find_or_create_by(phone: params[:phone])
    device = DeviceService.new(params, request).create_device_token(user)

    base_url = "https://api.kavenegar.com/v1/#{ENV["KAVENEGAR_API_KEY"]}"
    conn = Faraday.new base_url
    response = conn.get do |req|
      req.url "verify/lookup.json"
      req.body = {receptor: user.phone, token: device.verify, template: "verification" }.to_json
    end

    response = JSON.parse(response.body)
    if response.try(:[], 'return').try(:[], "status").to_i == 200
      device.update_attributes(verify_sent: Time.now)
      device
    else
      raise ServerError, 'sorry we have a problem right now'
    end
  end

  def access_authorize(params,  request)
    device = Device.find_by(verify: params['verify'])
    raise AuthError, "this token is not valid." unless device or device.verify_sent + ENV["VERIFY_TTL"] <= Time.now
    device = DeviceService.new(params, request).create_token(device)
  end
end
