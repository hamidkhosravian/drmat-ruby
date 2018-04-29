class ConversationService
  def get(sender_id, recipient_uuid)
    recipient_id = User.find_by!(uuid: recipient_uuid)
    conversation = Conversation.between(sender_id, recipient_id)
    return conversation if conversation.present?

    Conversation.create!(sender_id: sender_id, recipient_id: recipient_id)
  end
end
