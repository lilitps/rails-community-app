# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Viktor Schmidt",
             email: "viktorianer4life@gmail.com",
             password: "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

user = User.first
user.posts.create! content: "This is the first community post!"

if Rails.env.development?
  # Admins
  3.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)
  end

  # Users
  10.times do |n|
    name = Faker::Name.name
    email = "example-#{n+100}@railstutorial.org"
    password = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 activated: true,
                 activated_at: Time.zone.now)
  end

  # Posts by admins
  admins = User.where(admin: true)
  2.times do
    content = Faker::Lorem.sentence(5)
    admins.each {|user| user.posts.create!(content: content)}
  end

  # Posts by non admins
  users = User.where(admin: false)
  2.times do
    content = Faker::Lorem.sentence(5)
    users.each {|user| user.posts.create!(content: content)}
  end

  # Following relationships
  users = User.all
  user  = users.first
  following = users[2..users.count]
  followers = users[3..users.count - 5]
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }
end