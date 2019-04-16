# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

20.times do
  element = Element.create!(
    name: Faker::Creature::Animal.name,
    dimension: Faker::Lorem.words(2).join(' '),
    commentary: Faker::Lorem.sentence
  )

  50.times do
    user = User.create!(email: Faker::Internet.email)
    color = Faker::Color.color_name
    verb = Faker::Verb.simple_present
    objective = [
      'towards',
      'from',
      'to',
      'at',
      'into',
      'under',
      'beside'
    ].sample
    word = Faker::Hipster.words(1, false, true).first

    title = "#{color.capitalize} #{element.name} #{verb} #{objective} a #{word}"

    dream = Dream.create!(
      user: user,
      title: title,
      description: Faker::Lorem.paragraph,
      published: true
    )

    dream.elements << element

    puts title
  end
end

