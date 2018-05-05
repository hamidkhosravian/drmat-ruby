class Attachment < ApplicationRecord
    belongs_to :attachable, polymorphic: true

    has_attached_file :attach,
      path: ':rails_root/public/uploads/:attachable/:attachable_id/:filename-:hash.:extension',
      hash_secret: Rails.application.secrets.secret_key_base,
      url: '/uploads/:attachable/:attachable_id/:filename-:hash.:extension'

    validates_attachment_content_type :attach, content_type: [/\Aaudio\/.*\Z/, /\Avideo\/.*\Z/, /\Aapplication\/.*\Z/, /\Atext\/.*\Z/]

    private
      Paperclip.interpolates :attachable_id do |file, _style|
        file.instance.attachable.id
      end

      Paperclip.interpolates :attachable do |file, _style|
        name = "#{file.instance.attachable.class.to_s}s"
        name = "conversations/#{file.instance.attachable.conversation.uuid}" if name == 'Messages'
        name
      end
end
