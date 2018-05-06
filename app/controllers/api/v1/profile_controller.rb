module Api
  module V1
    class ProfileController < ApiController
      before_action :authenticate_user_from_token!

      def update
        @profile = current_user.profile
        raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @profile

        @profile.first_name = params['first_name'] if params['first_name']
        @profile.last_name = params['last_name'] if params['last_name']
        @profile.birthday = params['birthday'] if params['birthday']
        @profile.email = params['email'] if params['email']
        @profile.save!

        render 'api/v1/profile/show'
      end

      def show
        @profile = current_user.profile
        raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @profile

        render 'api/v1/profile/show'
      end

      def user_profile
        param! :uuid, String, blank: false, required: true

        @profile = User.find_by(uuid: params['uuid']).profile
        raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @profile
        render 'api/v1/profile/show'
      end

      def upload_image
        image = Image.create!(picture: params[:image], imageable: current_user)
        render 'api/v1/profile/show'
      end
    end
  end
end
