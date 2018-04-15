module Api
  module V1
    class AuthenticationController < ApiController
      def access_token
        param! :phone, String, blank: false, required: true

        @user = UserService.new.access(params, request)
        render 'api/v1/users/access_token'
      end

      def authorize_token
        param! :name, String, blank: false, required: true
        param! :uid, String, blank: false, required: true
        param! :agent, String, blank: false, required: true

        @device = UserService.new.authorize(params, request)
        render 'api/v1/users/authorize'
      end

      def logout
        logout_user!
      end

      def refresh_token
        param! :refresh_token, String, blank: false, required: true
        param! :uid, String, blank: false, required: true
        param! :name, String, blank: false, required: true
        param! :agent, String, blank: false, required: true

        @device = refresh_user!(params[:refresh_token], request)
        render 'api/v1/users/authorize'
      end
    end
  end
end
