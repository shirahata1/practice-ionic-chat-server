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
        comment = Comment.create!(comment_params.merge(user_id: @current_user.id))
        NotificationService.notify!(users: User.where.not(id: @current_user.id), body: comment.body)
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
