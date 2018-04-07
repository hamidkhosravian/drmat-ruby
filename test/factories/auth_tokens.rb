FactoryBot.define do
  factory :auth_token do
    token 'MyString'
    refresh_token 'MyString'
    socket_token 'MyString'
    token_expires_at '2018-04-07 13:48:36'
    refresh_token_expires_at 'MyString'
    socket_token_expires_at '2018-04-07 13:48:36'
    device nil
  end
end
