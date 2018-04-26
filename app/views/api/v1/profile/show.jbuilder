if (@current_user.profile == @profile) || @current_user.admin?
  json.partial! 'api/v1/_partials/profile/complate', profile: @profile
else
  json.partial! 'api/v1/_partials/profile/show', profile: @profile
end
