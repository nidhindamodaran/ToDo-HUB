module CommentsHelper
  def find_commenter(comment)
    user = User.find(comment.commenter)
  end
end
