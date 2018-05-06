module Api
  module V1
    module Admin
      class AdminController < AdminController
        before_action :authenticate_user_from_token!

        def create
          param! :email, String, blank: false, required: true
          param! :password, String, blank: false, required: true
          param! :password_confirmation, String, blank: false, required: true

          @user = AdminUserService.new.create(params, 'admin')
          render 'api/v1/users/access_token'
        end

        def show
          param! :uuid, String, blank: false, required: true

          @admin_user = AdminUser.where(role: 'admin').find_by(uuid: params['uuid'])
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @admin_user
          render 'api/v1/admin/user/admin'
        end

        def search
          param! :search, String, blank: false, required: true
          @admin_users = AdminUser.where(role: 'admin').
            where("CONCAT(phone, first_name, last_name, email) ILIKE ?", "#{params[:search]}%")

          render 'api/v1/admin/user/index'
        end

        def change_role
          param! :uuid, String, blank: false, required: true
          param! :role, String, blank: false, required: true

          @admin_user = AdminUser.where(role: 'admin').find_by(uuid: params['uuid'])
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @admin_user
          @admin_user.update_attributes!(role: role)

          render 'api/v1/admin/user/show'
        end

        def destroy
          param! :uuid, String, blank: false, required: true

          @admin_user = AdminUser.where(role: 'admin').find_by(uuid: params['uuid'])
          raise ProfileNotFoundError, I18n.t('messages.profile.not_found') unless @admin_user
          @admin_user.destroy!
        end
      end
    end
  end
end
