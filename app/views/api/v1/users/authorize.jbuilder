json.uuid @device.uuid
json.phone @device.user.phone
json.profile @device.user.profile
json.token do
  json.token @device.token.token
  json.token_expires_at @device.token.token_expires_at
  json.refresh_token @device.token.refresh_token
  json.refresh_token_expires_at @device.token.refresh_token_expires_at
  json.socket_token @device.token.socket_token
  json.socket_token_expires_at @device.token.socket_token_expires_at
end
