module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = verified_user
      logger.add_tags 'ActionCable', "Session #{current_user.uuid}"
    end

    protected

    def verified_user
      token = request.params[:socket_token]
      uuid = request.params[:uuid]
      begin
        auth  = AuthService.new(request).authenticate_socket_user!(token)
      rescue JWT::ExpiredSignature
        puts '*******************************************************'
        puts '*******  CABLE: rescued JWT::ExpiredSignature  ********'
        puts '*******************************************************'
      rescue JWT::DecodeError
        puts '*******************************************************'
        puts '**********  CABLE: rescued JWT::DecodeError  **********'
        puts '*******************************************************'
      end
      begin
        current_device = Device.find_by(uuid: uuid) if auth.present?
      rescue ActiveRecord::ActiveRecordError
        puts '*******************************************************'
        puts '**********  CABLE: rescued ActiveRecordError **********'
        puts '*******************************************************'
      end
      if current_device = auth
        current_device.user
      else
        reject_unauthorized_connection
      end
    end
  end
end
