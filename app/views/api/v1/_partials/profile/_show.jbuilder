json.first_name profile.first_name
json.last_name profile.last_name
json.birthday profile.birthday
json.user_uuid profile.user.uuid

json.image do
  json.partial! 'api/v1/_partials/image', image: profile.image if profile.image.present?
end
