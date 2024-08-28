class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :create ]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("post_#{comment_params[:post_id]}_comments", partial: "comments/comments", locals: { comments: @post.reload.comments })
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post


    respond_to do |format|
      format.turbo_stream do
        @comment.destroy
        render turbo_stream: turbo_stream.update("post_#{@comment.post_id}_comments", partial: "comments/comments", locals: { comments: @post.reload.comments })
      end
    end
  end

  private

  def set_post
    @post = current_user.posts.find(comment_params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :id)
  end
end
