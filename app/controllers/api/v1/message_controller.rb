module Api
  module V1
    class MessageController < ApiController
      before_action :authenticate_user_from_token!

      def index
        param! :page, Integer, default: 1
        param! :limit, Integer, default: 10
        param! :conversation_uuid, String, blank: false, required: true

        @messages = MessageService.new.list(params[:conversation_uuid], params[:page], params[:limit])

        render 'api/v1/messages/index'
      end

      def create
        param! :conversation_uuid, String, blank: false, required: true
        param! :user_uuid, String, blank: false, required: true
        param! :body, String, blank: false, required: true

        @message = MessageService.new.create(params[:conversation_uuid], params[:user_uuid], params[:body])

        render 'api/v1/messages/show'
      end

      def upload_image
        param! :conversation_uuid, String, blank: false, required: true
        param! :user_uuid, String, blank: false, required: true
        
        @message = MessageService.new.create(params[:conversation_uuid], params[:user_uuid], params[:attachment])
      end
    end
  end
end
