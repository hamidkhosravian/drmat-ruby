module Api
  module V1
    class MessageController < ApiController
      before_action :authenticate_user_from_token!

      def create
        param! :recipient_uuid, String, blank: false, required: true
        param! :user_uuid, String, blank: false, required: true
        param! :body, String, blank: false, required: true

        @message = MessageService.new.create(recipient_uuid, user_uuid, body)

        render 'api/v1/message/show'
      end
    end
  end
end
