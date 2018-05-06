class MessageService
  def create(conversation_id, user_id, body)
    message = Message.create!(user_id: user_id, conversation_id: conversation_id, body: body)
    MessageBroadcastJob.perform_later(message)
    message
  end

  def list(conversation_uuid, page, limit)
    conversation = Conversation.find_by!(uuid: conversation_uuid)
    messages = conversation.messages.order('created_at DESC')
      .page(params[:page]).per(params[:limit])
  end

  def upload(conversation_id, user_id, attachment, body)
    attach_format = Regexp.union([
      /\Aaudio\/.*\Z/, /\Avideo\/.*\Z/,
      /\Aapplication\/.*\Z/, /\Atext\/.*\Z/
    ])

    message = Message.create!(user_id: user_id, conversation_id: conversation_id, body: body)

    if attach_format.match?(attachment.content_type)
      attach = Attachment.create!(attach: attachment, attachable: message)
    elsif (/\Aimage\/.*\Z/).match?(attachment.content_type)
      image = Image.create!(picture: attachment, imageable: message)
    else
      raise BadRequestError, I18n.t('messages.attachment.valid.faild')
    end

    MessageBroadcastJob.perform_later(message)
    message
  rescue
    message.destroy!
  end
end
