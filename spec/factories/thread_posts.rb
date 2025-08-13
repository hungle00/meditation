FactoryBot.define do
  factory :thread_post do
    sequence(:title) { |n| "Thread Title #{n}" }
    sequence(:content) { |n| "This is the content for thread #{n}" }
    association :user
  end
end
