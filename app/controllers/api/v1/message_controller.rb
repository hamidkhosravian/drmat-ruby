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

      def upload_file
        conversation = Conversation.find_by!(uuid: params[:conversation_uid])

        raise BadRequestError, I18n.t('messages.http._401') unless
          (current_user.id == conversation.sender_id) || (current_user.id == conversation.recipient_id)

        @message = MessageService.new.upload(conversation.id, current_user.id, params[:attachment], params[:body])

        render 'api/v1/messages/show'
      end
    end
  end
end
