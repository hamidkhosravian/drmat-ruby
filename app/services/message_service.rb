class MessageService
  def create(conversation_uuid, user_uuid, body)
    conversation = Conversation.find_by!(uuid: conversation_uuid)
    user = User.find_by!(uuid: user_uuid)

    message = Message.create!(user_id: user.id, conversation_id: conversation.id, body: body)
  end

  def list(conversation_uuid, page, limit)
    conversation = Conversation.find_by!(uuid: conversation_uuid)
    messages = conversation.messages.order("created_at DESC")
      .page(params[:page]).per(params[:limit]))
  end
end
