FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "This is comment #{n}" }
    association :thread_post
    association :user
    parent { nil } # Default to no parent (top-level comment)
  end
end
