module Api
  module V1
    class AuthenticationController < ApiController
      def access_token
        @user = UserService.new.access(params, request)
        render "api/v1/users/access"
      end

      def authorize_token
        @device = UserService.new.authorize(params, request)
        render "api/v1/users/authorize"
      end

      def logout
        logout_user!
      end

      def refresh_token
        param! :refresh_token, String, blank: false, required: true

        raise BadRequestError, I18n.t("messages.device.details_error") if params.try(:[], "device").try(:[], "uid").blank? && request.session.blank?

        @device = refresh_user!(params[:refresh_token], request)
        render "api/v1/devices/show"
      end
    end
  end
end
