json.conversation_uuid conversation.uuid
json.created_at conversation.created_at
json.updated_at conversation.updated_at
json.opposed_user do
  json.partial! 'api/v1/_partials/profile/show', profile: conversation.opposed_user(current_user)
end
