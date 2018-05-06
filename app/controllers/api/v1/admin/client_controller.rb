module Api
  module V1
    module Admin
      class ClientController < AdminController
        before_action :authenticate_user_from_token!

        def show
          param! :uuid, String, blank: false, required: true

          @profile = User.where(role: 'client').find_by(uuid: params['uuid']).profile
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @profile
          render 'api/v1/admin/profile/client'
        end

        def search
          param! :search, String, blank: false, required: true
          @profiles = User.joins(:profile).where(role: 'client').
            where("CONCAT(phone, profiles.first_name, profiles.last_name, profiles.email) ILIKE ?", "#{params[:search]}%")

          render 'api/v1/admin/profile/index'
        end

        def change_role
          param! :uuid, String, blank: false, required: true
          param! :role, String, blank: false, required: true

          user = User.where(role: 'client').find_by(uuid: params['uuid'])
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless user
          user.update_attributes!(role: role)

          @profile = user.profile
          render 'api/v1/admin/profile/show'
        end
      end
    end
  end
end
