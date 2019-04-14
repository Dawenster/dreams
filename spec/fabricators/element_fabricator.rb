Fabricator(:element) do
  name Faker::Lorem.word
  dimension Faker::Lorem.words(2).join(' ')
  commentary Faker::Lorem.sentence
end
