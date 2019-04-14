# == Schema Information
#
# Table name: elements
#
#  id         :uuid             not null, primary key
#  commentary :text             not null
#  dimension  :string           not null
#  image_url  :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Element < ActiveRecord::Base
  has_and_belongs_to_many :dreams
end
