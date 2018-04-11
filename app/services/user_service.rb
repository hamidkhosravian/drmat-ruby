class UserService
  def access(params, request)
    phone_object = TelephoneNumber.parse(params[:phone], :ir)
    byebug
    user = User.find_or_create_by!(phone: "0#{phone_object.normalized_number}")
    secure_number = SecureRandom.hex(3)

    base_url = "https://api.kavenegar.com/v1/#{ENV["KAVENEGAR_API_KEY"]}"
    conn = Faraday.new base_url
    response = conn.post do |req|
      req.url 'verify/lookup.json'
      req.params["receptor"] = user.phone
      req.params["token"] = secure_number
      req.params["template"] = "verification"
    end

    response = JSON.parse(response.body)
    user.update_attributes(verify: secure_number, verify_sent_at: Time.now) if response.try(:[], 'return').try(:[], 'status').to_i == 200

    user
  end

  def authorize(params,  request)
    user = User.find_by(verify: params['verify'])
    raise BadRequestError, 'token is not valid.' unless user and (DateTime.parse((user.verify_sent_at + ENV['VERIFY_TTL'].to_i.minutes).to_s) >= DateTime.now)
    device = DeviceService.new(params, request).create_or_find_device(user)
    DeviceService.new(params, request).create_token(device)
    device
  end
end
