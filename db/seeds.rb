# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

User.destroy_all
ThreadPost.destroy_all
Comment.destroy_all

5.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )

  rand(5..10).times do
    user.threads.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      content: Faker::Lorem.paragraph(sentence_count: 4)
    )

    rand(1..3).times do
    end
  end
end

user_ids = User.pluck(:id)
thread_ids = ThreadPost.pluck(:id)
20.times do
  Comment.create!(
    thread_post_id: thread_ids.sample,
    user_id: user_ids.sample,
    content: Faker::Lorem.sentence(word_count: 10)
  )
end

ThreadPost.find_each do |thread|
  ThreadPost.reset_counters(thread.id, :comments)
end
