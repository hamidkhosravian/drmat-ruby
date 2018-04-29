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
    conversation = Conversation.find_by!(uuid: body["conversation_uid"])
    Message.create!(body: body["message"], user: current_user, conversation: conversation)
  end
end
