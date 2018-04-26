module Api
    module V1
        class ConversationController < ApiController
            before_action :authenticate_user_from_token!

            def index
                @conversations = Conversation.
                    where('(conversations.sender_id = ? OR conversations.recipient_id = ?)',
                            current_user.id, current_user.id)
            end
        end
    end
end