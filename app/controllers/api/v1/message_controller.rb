module Api
  module V1
    class MessageController < ApiController
      before_action :authenticate_user_from_token!

      def index
        param! :page, Integer, default: 1
        param! :limit, Integer, default: 10
        param! :conversation_uuid, String, blank: false, required: true

        @messages = MessageService.new.list(conversation_uuid, page, limit)

        render 'api/v1/message/index'
      end

      def create
        param! :conversation_uuid, String, blank: false, required: true
        param! :user_uuid, String, blank: false, required: true
        param! :body, String, blank: false, required: true

        @message = MessageService.new.create(conversation_uuid, user_uuid, body)

        render 'api/v1/message/show'
      end
    end
  end
end
