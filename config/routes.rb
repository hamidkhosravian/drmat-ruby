Rails.application.routes.draw do
  get '/' => 'welcome#index'

  namespace :api do
    namespace :v1 do
      # Authentication
      post   'access_token'     => 'authentication#access_token'
      post   'authorize_token'  => 'authentication#authorize_token'
      put    'refresh_token' => 'authentication#refresh_token'
      delete 'logout'        => 'authentication#logout'

      # Profile
      get  'profile'        => 'profile#show'
      get  'profile/:uuid'  => 'profile#show'
      post 'profile'        => 'profile#create'
      post 'profile/upload' => 'profile#upload_image'
      put  'profile'        => 'profile#update'

      # Conversation
      get  'conversations'  => 'conversations#index'
      post 'conversations'  => 'conversations#create'
      post 'conversations/:uuid'  => 'conversations#show'

      # Message
      post 'conversations/:conversation_uuid/upload' => 'message#upload_file'
    end
  end
end
