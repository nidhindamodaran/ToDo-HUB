module TasksHelper
  def total_completion(task)
    total = 0;
    count = task.participants.count
    task.participants.each do |participant|
      total += participant.progression
    end
    avg_progression = total/count
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
