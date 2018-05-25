module Api
  module V1
    class SessionsController < ApiController
      def create
        user = User.find_by!(authorized_id: params[:authorized_id])
        fail ActionController::BadRequest unless user.authenticate(params[:password])
        render json: user, root: false
      end
    end
  end
end
