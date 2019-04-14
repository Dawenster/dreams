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

Fabricator(:element) do
  name Faker::Lorem.word
  dimension Faker::Lorem.words(2).join(' ')
  commentary Faker::Lorem.sentence
end
