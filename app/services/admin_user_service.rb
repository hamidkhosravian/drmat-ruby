class AdminUserService
  def access(params, request)
    phone_object = TelephoneNumber.parse(params[:phone], :ir)
    user = User.find_or_create_by!(phone: "0#{phone_object.normalized_number}")
    secure_number = SecureRandom.hex(3)

    base_url = "https://api.kavenegar.com/v1/#{ENV["KAVENEGAR_API_KEY"]}"
    conn = Faraday.new base_url
    response = conn.post do |req|
      req.url 'verify/lookup.json'
      req.params['receptor'] = user.phone
      req.params['token'] = secure_number
      req.params['template'] = 'verification'
    end

    response = JSON.parse(response.body)
    user.update_attributes(verify: secure_number, verify_sent_at: Time.now) if response.try(:[], 'return').try(:[], 'status').to_i == 200

    user
  end

  def create
  end
end
