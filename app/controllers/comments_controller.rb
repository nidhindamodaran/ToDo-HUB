class CommentsController < ApplicationController
  respond_to :html, :js
  def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.new(comment_params)
    @comment.commenter = current_user.id
    @comment.user_name = current_user.name
    @comment.save
    redirect_to task_path(@task)
  end
  def destroy
    @task = Task.find(params[:task_id])
    @comment = @task.comments.find(params[:id])
    @comment.destroy
    redirect_to task_path(@task)
  end

  private

    def comment_params
      params.require(:comment).permit(:commenter, :comment)
    end
end
