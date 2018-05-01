class FailedBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, object, error, type)
    broadcast_to_sender(user, object, error, type)
  end

  private

  def broadcast_to_sender(user, object, error, type)
    ActionCable.server.broadcast(
      "#{type}-#{user.uuid}",
      error: render_error(user, object, error, type),
    )
  end

  def render_error(user, object, error, type)
    uid = object&.uuid
    ApplicationController.render(
      partial: "api/v1/_partials/error",
      locals: { uid: uid, error: error, type: type}
    )
  end
end
