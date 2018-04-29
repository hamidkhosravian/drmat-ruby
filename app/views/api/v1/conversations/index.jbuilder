json.partial! "api/v1/partials/pagination_info", list: @conversations
json.conversations @conversations do |conversation|
  json.partial! 'api/v1/_partials/conversation/show', conversation: conversation
end
