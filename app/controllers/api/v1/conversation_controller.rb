module Api
    module V1
        class ConversationController < ApiController
            before_action :authenticate_user_from_token!

            def index
                @conversations = Conversation.
                    where('(conversations.sender_id = ? OR conversations.recipient_id = ?)',
                            current_user.id, current_user.id)

                render 'api/v1/conversation/index'
            end

            def create
              param! :recipient_uuid, String, blank: false, required: true
              @conversation = ConversationService.new.get(current_user.id, params[:recipient_uuid])

              render 'api/v1/conversation/show'
            end

            def create
              param! :conversation_uuid, String, blank: false, required: true
              @conversation = Conversation.find_by!(uuid: params[:conversation_uuid])

              render 'api/v1/conversation/show'
            end
        end
    end
end
