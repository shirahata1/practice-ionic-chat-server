module Api
  module V1
    class CommentsController < ApiController
      before_action :authenticate

      def index
        comments = if params.has_key?(:beginning_from)
          Comment.where("comments.id >= ?", params[:beginning_from])
        else
          Comment.all.limit(20)
        end
        comments = comments.order(id: :desc)
        render json: comments, root: false
      end

      def create
        comment = Comment.create!(comment_params.merge(user_id: @current_user.id))
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
