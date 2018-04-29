json.conversations @conversations do |conversation|
  json.partial! 'api/v1/_partials/conversation/show', conversation: conversation
end
