class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  has_attached_file :picture, styles: { medium: '300x300>', thumb: '100x100>' },
    path: ':rails_root/public/uploads/:imageable/:imageable_id/:filename-:hash.:extension',
    hash_secret: Rails.application.secrets.secret_key_base,
    url: '/uploads/:imageable/:imageable_id/:filename-:hash.:extension'

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  private
    Paperclip.interpolates :imageable_id do |file, _style|
      file.instance.imageable.id
    end

    Paperclip.interpolates :imageable do |file, _style|
      name = "#{file.instance.imageable.class.to_s}s"
      name = "conversations/#{file.instance.imageable.conversation.uuid}" if name == 'Messages'
      name
    end
end
