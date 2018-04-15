module Api
  module V1
    class ProfileController < ApiController
      before_action :authenticate_user_from_token!, except: [:index]

      def create
      end

      def update
      end

      def show
      end

      def user_profile
      end
    end
  end
end
