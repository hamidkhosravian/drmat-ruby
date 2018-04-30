class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "conversations-#{current_user.uuid}"
  end

  def unsubscribed
    stop_all_streams
  end

  def conversation(data)
    body = data['body']
    user = User.find_by!(uuid: body['user_uid'])
    if user.present?
      conversation = Conversation.create!(sender_id: current_user, recipient_id: user)
    else
      # TODO: send to job other ActionCable
    end
  end

  def speak(data)
    body = data['body']
    conversation = Conversation.find_by!(uuid: body['conversation_uid'])
    if current_user.id == conversation.sender_id or current_user.id == conversation.recipient_id
      if conversation.present?
        Message.create!(body: body['message'], user: current_user, conversation: conversation)
      elsif !conversation.present?
        # TODO: send to job other ActionCable
      end
    else
      puts '***************************************************************'
      puts '*******  CABLE: User cannot join to this conversation  ********'
      puts '***************************************************************'
    end
  end
end
