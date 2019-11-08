# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.find_by(email: ENV['ADMIN_EMAIL'])
  User.create!(name: ENV['ADMIN_NAME'],
               email: ENV['ADMIN_EMAIL'],
               password: Rails.application.credentials.admin[:password],
               password_confirmation: Rails.application.credentials.admin[:password],
               admin: true,
               locale: 'en',
               active: true,
               approved: true,
               confirmed: true,
               activated_at: Time.zone.now)

  user = User.first
  user.posts.create! content: 'This is the first community post!'
end

if Rails.env.development?
  # Admins
  3.times do |n|
    next if User.find_by(email: "example-#{n + 1}@railstutorial.org")
    name = Faker::Name.name
    email = "example-#{n + 1}@railstutorial.org"
    password = 'password'
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 admin: true,
                 locale: 'en',
                 active: true,
                 approved: true,
                 confirmed: true,
                 activated_at: Time.zone.now)
  end

  # Users
  10.times do |n|
    next if User.find_by(email: "example-#{n + 100}@railstutorial.org")
    name = Faker::Name.name
    email = "example-#{n + 100}@railstutorial.org"
    password = 'password'
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 locale: 'en',
                 active: true,
                 approved: true,
                 confirmed: true,
                 activated_at: Time.zone.now)
  end

  # Posts by admins
  admins = User.where(admin: true)
  2.times do
    content = Faker::Lorem.sentence(word_count: 5)
    admins.each { |admin| admin.posts.create!(content: content) }
  end

  # Posts by non admins
  non_admins = User.where(admin: false)
  2.times do
    content = Faker::Lorem.sentence(word_count: 5)
    non_admins.each { |non_admin| non_admin.posts.create!(content: content) }
  end

  # Following relationships
  non_admins = User.all
  user = non_admins.first
  following = non_admins[2..non_admins.count]
  followers = non_admins[3..non_admins.count - 5]
  following.each { |followed| user.follow(followed) unless user.following? followed }
  followers.each { |follower| follower.follow(user) unless follower.following? user }
end
