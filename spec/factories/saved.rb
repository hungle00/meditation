FactoryBot.define do
  factory :saved do
    association :user
    association :savable, factory: :thread_post
  end
end
