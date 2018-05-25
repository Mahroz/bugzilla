# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "John Doe",
  email: "manager@test.com",
  password: "password",
  password_confirmation: "password",
  user_type: 0)

  1000.times do |n|
    name = Faker::Name.name
    email = name.downcase.tr(" " , ".") + "@test.com"
    password = "password"
    user_type = Random.new.rand(0..2)
    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password,
      user_type: user_type
    )
  end
