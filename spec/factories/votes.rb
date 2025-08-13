FactoryBot.define do
  factory :vote do
    association :voter, factory: :user

    # Default to voting on a thread_post, but can be overridden
    association :votable, factory: :thread_post
  end
end
