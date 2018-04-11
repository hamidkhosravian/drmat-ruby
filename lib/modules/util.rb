module Util
  def set_uid
    self.uid = SecureRandom.uuid
    # self.save
  end

  def generate_random_secure(number)
    o = [('0'..'9'), ('a'..'z')].map(&:to_a).flatten
    res = (1..number).map { o[rand(o.length)] }.join
    res
  end
end
