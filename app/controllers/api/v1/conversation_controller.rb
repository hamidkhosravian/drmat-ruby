module Api
    module V1
        class ConversationController < ApiController
            before_action :authenticate_user_from_token!

            def index
              param! :page, Integer, default: 1
              param! :limit, Integer, default: 10

              @conversations = Conversation.
                  where('(conversations.sender_id = ? OR conversations.recipient_id = ?)',
                          current_user.id, current_user.id).order('created_at DESC').joins(:messages).distinct
                          .page(params[:page]).per(params[:limit])

              render 'api/v1/conversations/index'
            end

            def create
              param! :recipient_uid, String, blank: false, required: true
              param! :sender_uid, String, blank: false, required: true

              # @conversation = ConversationService.new.get(current_user.uuid, params[:recipient_uuid])
              @conversation = ConversationService.new.get(params[:sender_uid], params[:recipient_uid])

              render 'api/v1/conversations/show'
            end

            def show
              @conversation = Conversation.find_by!(uuid: params[:uid])
              render 'api/v1/conversations/show'
            end
        end
    end
end
