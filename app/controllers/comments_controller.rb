class CommentsController < ApplicationController
  before_filter :find_task
  respond_to :html, :js

  def create
    @comment = @task.comments.new(comment_params)
    @comment.commenter = current_user.id
    @comment.user_name = current_user.name
    @comment.save
  end
  
  def destroy
    @comment = @task.comments.find(params[:id])
    @comment.destroy
  end

  private

    def find_task
      @task = Task.find(params[:task_id])
    end

    def comment_params
      params.require(:comment).permit(:commenter, :comment)
    end
end
