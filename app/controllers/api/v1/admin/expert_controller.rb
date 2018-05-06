module Api
  module V1
    module Admin
      class ExpertController < AdminController
        before_action :authenticate_user_from_token!

        def create
          param! :phone, String, blank: false, required: true

          @user = AdminUserService.new.access(params, request, 'expert')
          render 'api/v1/users/access_token'
        end

        def show
          param! :uuid, String, blank: false, required: true

          @profile = User.where(role: 'expert').find_by(uuid: params['uuid']).profile
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @profile
          render 'api/v1/admin/profile/expert'
        end

        def search
          param! :search, String, blank: false, required: true
          @profiles = User.joins(:profile).where(role: 'expert')
            where("CONCAT(phone, profiles.first_name, profiles.last_name, profiles.email) ILIKE ?", "#{params[:search]}%")

          render 'api/v1/admin/profile/index'
        end

        def change_role
          param! :uuid, String, blank: false, required: true
          param! :role, String, blank: false, required: true

          user = User.where(role: 'expert').find_by(uuid: params['uuid'])
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless user
          user.update_attributes!(role: role)

          @profile = user.profile
          render 'api/v1/admin/profile/show'
        end
      end
    end
  end
end
