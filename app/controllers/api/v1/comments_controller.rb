module Api
  module V1
    class CommentsController < ActionController::API
      def index
        comments = if params.has_key?(:range)
          range = JSON.parse(params[:range])
          Comment.search_by_range_ids(gte: range['gte'], lte: range['lte'])
        else
          Comment.all.limit(20)
        end
        comments = comments.order(id: :desc)
        render json: comments
      end

      def create
        comment = Comment.create!(comment_params)
        render json: comment
      end

      def update
        comment = Comment.find(params[:id])
        comment.update!(comment_params)
        comment.reload
        render json: comment
      end

      def destroy
        comment = Comment.find(params[:id])
        comment.destroy!
        render json: comment
      end

      private

      def comment_params
        params.permit(:body)
      end
    end
  end
end
