# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

1000.times do
  user = User.create!(email: Faker::Internet.email)
  animal = Faker::Creature::Animal.name
  color = Faker::Color.color_name
  verb = Faker::Verb.simple_present
  objective = ['towards', 'from', 'to', 'at', 'into', 'under', 'beside'].sample
  word1, word2 = Faker::Hipster.words(2, false, true)

  title = "#{color.capitalize} #{word1} #{animal} #{verb} #{objective} a #{word2}"

  Dream.create(
    user: user,
    title: title
  )

  puts "Created dream with title: #{title}"
end
