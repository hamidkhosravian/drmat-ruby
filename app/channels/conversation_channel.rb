class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "conversations-#{current_user.uuid}"
  end

  def unsubscribed
    stop_all_streams
  end

  def start_conversation
    body = data['body']
    if body['message'].present?
      recipient = User.find_by!(uuid: body["recipient_uid"])
      conversation = ConversationService.new.get(current_user.id, params[:recipient_uuid])
      Message.create!(body: body['message'], user: current_user, conversation: conversation)
    end
  rescue ActiveRecord::RecordNotFound
    FailedBroadcastJob.perform_later(current_user, nil, I18n.t('messages.profile.not_found'), 'users')
  end

  def speak(data)
    body = data['body']
    conversation = Conversation.find_by!(uuid: body['conversation_uid'])
    if (current_user.id == conversation.sender_id) || (current_user.id == conversation.recipient_id)
      Message.create!(body: body['message'], user: current_user, conversation: conversation)
    else
      FailedBroadcastJob.perform_later(current_user, conversation, I18n.t('messages.http._401'), 'conversations')

      # TODO: remove in production mode
      puts '***************************************************************'
      puts '*******  CABLE: User cannot join to this conversation  ********'
      puts '***************************************************************'
    end
  rescue ActiveRecord::RecordNotFound
    FailedBroadcastJob.perform_later(current_user, nil, I18n.t('messages.conversation.not_found'), 'conversations')
  end
end
