module Api
  module V1
    class CurrentUsersController < ApiController
      before_action :authenticate

      def update
        @current_user.update!(account_params)
        @current_user.reload
        render json: @current_user, root: false
      end

      private

      def account_params
        params.permit(:notification_token)
      end
    end
  end
end
