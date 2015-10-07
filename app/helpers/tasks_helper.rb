module TasksHelper
  def total_completion(task)
    Participant.find_total_progression(task.id).to_i
  end

  def creator(task)
    User.find(task.user_id)
  end

  def link_extract(text)
    linked = text.gsub( %r{http://[^\s<]+} ) do |url|
      if url[/(?:png|jpe?g|gif|svg)$/]
        "<img src='#{url}' />"
      else
        "<a href='#{url}'>#{url}</a>"
      end
   end
  end
end
