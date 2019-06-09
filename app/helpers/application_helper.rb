module ApplicationHelper
  def frontend_url
    'https://send-dreams.herokuapp.com'
  end

  def dream_url(dream)
    "#{frontend_url}/dreams/#{dream.id}"
  end
end
