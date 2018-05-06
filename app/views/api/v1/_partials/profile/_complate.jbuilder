json.first_name profile.first_name
json.last_name profile.last_name
json.birthday profile.birthday
json.email profile.email
json.phone profile.user.phone
json.user_uuid profile.user.uuid

json.image do
  json.partial! 'api/v1/_partials/image', image: profile.image if profile.image.present?
end
