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

class ElementSerializer
  include FastJsonapi::ObjectSerializer

  set_type :element

  attributes :name, :dimension, :commentary, :image_url
end
