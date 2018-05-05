json.id message.id
json.body message.body
json.created_at message.created_at
json.updated_at message.updated_at
json.user_uuid  message.user.uuid

json.attachment do
  json.partial! 'api/v1/_partials/attachment', attachment: message.attachment if message.attachment.present?
end

json.image do
  json.partial! 'api/v1/_partials/image', image: message.image if message.image.present?
end
