class ConversationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(conversation)
    sender = conversation.sender
    broadcast_to_sender(sender, conversation)
  end

  private

  def broadcast_to_sender(user, conversation)
    ActionCable.server.broadcast(
      "conversations-#{user.uuid}",
      conversation: render_conversation(conversation, user),
      conversation_uuid: conversation.conversation.uuid
    )
  end

  def render_conversation(conversation, user)
    ApplicationController.render(
      partial: 'api/v1/_partials/conversation/show',
      locals: { conversation: conversation, profile: user.profile }
    )
  end
end
