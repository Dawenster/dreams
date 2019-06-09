module ApplicationHelper
  def frontend_url
    'https://send-dreams.herokuapp.com'
  end

  def dream_url(dream)
    "#{frontend_url}?dream=#{dream.id}"
  end
end
