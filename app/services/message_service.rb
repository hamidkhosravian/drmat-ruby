class MessageService
  def create(conversation_uuid, user_uuid, body)
    conversation = Conversation.find_by!(uuid: conversation_uuid)
    user = User.find_by!(uuid: user_uuid)

    message = Message.create!(user_id: user.id, conversation_id: conversation.id, body: body)
  end
end
