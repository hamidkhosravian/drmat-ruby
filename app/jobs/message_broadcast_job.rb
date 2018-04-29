class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    sender = message.user
    recipient = message.conversation.opposed_user(sender)

    broadcast_to_sender(sender, message)
    broadcast_to_recipient(recipient, message)
  end

  private

  def broadcast_to_sender(user, message)
    ActionCable.server.broadcast(
      "conversations-#{user.uuid}",
      message: render_message(message, user),
      conversation_uuid: message.conversation.uuid
    )
  end

  def broadcast_to_recipient(user, message)
    ActionCable.server.broadcast(
      "conversations-#{user.uuid}",
      window: render_window(message.conversation, user),
      message: render_message(message, user),
      conversation_uuid: message.conversation.uuid
    )
  end

  def render_message(message, user)
    ApplicationController.render(
      partial: 'api/v1/_partials/message/show',
      locals: { message: message, profile: user.profile, user_uuid: user.uuid }
    )
  end

  def render_window(conversation, user)
    ApplicationController.render(
      partial: 'api/v1/_partials/conversation/show',
      locals: { conversation: conversation, profile: user.profile, user_uuid: user.uuid, current_user: conversation.sender }
    )
  end
end
