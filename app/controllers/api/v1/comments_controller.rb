module Api
  module V1
    class CommentsController < ApiController
      before_action :authenticate

      def index
        comments = Comment.all
        limit = params.has_key?(:limit) ? params[:limit].to_i : 20
        comments = comments.limit(limit)
        comments = comments.offset(params[:offset].to_i) if params.has_key?(:offset)
        comments = comments.includes(:user).order(id: :desc)
        render json: comments, root: false
      end

      def create
        comment = nil

        ActiveRecord::Base.transaction do
          comment = Comment.create!(comment_params.merge(user_id: @current_user.id))
          users = User.select('DISTINCT users.notification_token')
                       .where.not(id: @current_user.id)
                       .where.not(notification_token: nil)
          NotificationService.notify!(users: users, body: comment.body)
        end

        render json: comment, root: false
      end

      def update
        comment = Comment.find(params[:id])
        comment.update!(comment_params)
        comment.reload
        render json: comment, root: false
      end

      def destroy
        comment = Comment.find(params[:id])
        comment.destroy!
        render json: comment, root: false
      end

      private

      def comment_params
        params.permit(:body)
      end
    end
  end
end
