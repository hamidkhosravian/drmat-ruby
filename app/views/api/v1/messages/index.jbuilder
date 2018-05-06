json.partial! 'api/v1/partials/pagination_info', list: @messages
json.messages @messages do |message|
  json.partial! 'api/v1/_partials/message/show', message: message
end
