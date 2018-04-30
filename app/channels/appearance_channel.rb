class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    redis.set("user_#{current_user.uuid}_online", '1')
    stream_from('appearances_channel')
    ActionCable.server.broadcast 'appearances_channel',
                                 type: 'user_appearance',
                                 user_id: current_user.uuid,
                                 online: true
  end

  def unsubscribed
    redis.del("user_#{current_user.uuid}_online")
    ActionCable.server.broadcast 'appearances_channel',
                                 type: 'user_appearance',
                                 user_id: current_user.uuid,
                                 online: false
  end

  private

  def redis
    Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: 15)
  end
end
