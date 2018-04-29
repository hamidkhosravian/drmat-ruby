module Api
    module V1
        class ConversationController < ApiController
            before_action :authenticate_user_from_token!

            def index
              param! :page, Integer, default: 1
              param! :limit, Integer, default: 10

              @conversations = Conversation.
                  where('(conversations.sender_id = ? OR conversations.recipient_id = ?)',
                          current_user.id, current_user.id).order("created_at DESC")
                          .page(params[:page]).per(params[:limit])

              render 'api/v1/conversations/index'
            end

            def create
              param! :recipient_uuid, String, blank: false, required: true
              @conversation = ConversationService.new.get(current_user.id, params[:recipient_uuid])

              render 'api/v1/conversations/show'
            end

            def show
              param! :conversation_uuid, String, blank: false, required: true
              @conversation = Conversation.find_by!(uuid: params[:conversation_uuid])
              render 'api/v1/conversations/show'
            end
        end
    end
end
