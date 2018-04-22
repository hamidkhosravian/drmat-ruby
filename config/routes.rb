Rails.application.routes.draw do
  get '/' => 'welcome#index'

  namespace :api do
    namespace :v1 do
      post   'access_token'        => 'authentication#access_token'
      post   'authorize_token'     => 'authentication#authorize_token'
      put    'refresh_token' => 'authentication#refresh_token'
      delete 'logout'        => 'authentication#logout'

      get  'profile'        => 'profile#show'
      get  'profile/:uuid'  => 'profile#show'
      post 'profile'        => 'profile#create'
      put  'profile'        => 'profile#update'
    end
  end
end
