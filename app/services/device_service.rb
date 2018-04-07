class DeviceService
  def initialize(params, request)
    @params = params
    @request = request
  end

  def create_device_token(user)
    user_agent = UserAgent.parse @request.user_agent
    uuid = @params.try(:[], "device").try(:[], "uid") || @request.session.id
    device = user.devices.find_by(uuid: uuid)

    if device
      device.update_attributes(verify: SecureRandom.hex(3))
    else
      device = create_device(user)
    end
  end

  def create_device(user)
    device = user.devices.new
    user_agent = UserAgent.parse @request.user_agent
    uuid = @params.try(:[], "device").try(:[], "uid") || @request.session.id
    name = @params.try(:[], "device").try(:[], "name") || user_agent.browser

    if user_agent.first.comment.to_s.downcase.include? "android"
      device.os = 0
    elsif user_agent.first.comment.to_s.downcase.include? "ios"
      device.os = 1
    elsif user_agent.first.comment.to_s.downcase.include? "windows"
      device.os = 2
    elsif user_agent.first.comment.to_s.downcase.include? "linux"
      device.os = 3
    elsif user_agent.first.comment.to_s.downcase.include? "os" || "macintosh"
      device.os = 4
    end

    device.name = name
    device.uuid = uuid
    device.device_last_ip = @request.remote_ip
    device.device_current_ip = @request.remote_ip
    device.verify = SecureRandom.hex(3)
    device.save!
    device
  end

  def create_token(device)
    device.device_last_ip = device.device_current_ip
    device.device_current_ip = @request.remote_ip
    device.updated_at = Time.now
    device.verify = SecureRandom.hex(3)
    device.invalidate_auth_token
    device.generate_auth_token
    device.update_tracked_fields(@request.env)
    device.save!
    device
  end
end
