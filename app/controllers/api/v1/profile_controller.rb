module Api
  module V1
    class ProfileController < ApiController
      before_action :authenticate_user_from_token!

      def create
        param! :first_name, String, blank: false, required: true
        param! :last_name, String, blank: false, required: true
        param! :birthday, String, blank: false, required: true

        @profile = Profile.new
        @profile.user = current_user
        @profile.first_name = params['first_name']
        @profile.last_name = params['last_name']
        @profile.birthday = params['birthday']
        @profile.email = params['email']
        @profile.save!

        render 'api/v1/profile/show'
      end

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
    end
  end
end
