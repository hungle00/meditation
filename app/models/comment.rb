class Comment < ApplicationRecord
  belongs_to :thread_post, counter_cache: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :subcomments, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
end
