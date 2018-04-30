class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "conversations-#{current_user.uuid}"
  end

  def unsubscribed
    stop_all_streams
  end

  def speak(data)
    body = data['body']
    conversation = Conversation.find_by!(uuid: body['conversation_uid'])
    if current_user.id == conversation.sender_id or current_user.id == conversation.recipient_id
      Message.create!(body: body['message'], user: current_user, conversation: conversation)
    else
      puts '***************************************************************'
      puts '*******  CABLE: User cannot join to this conversation  ********'
      puts '***************************************************************'
    end
  end
end
