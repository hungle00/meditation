class ThreadPost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy, counter_cache: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :saveds, as: :savable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :thread_with_comments, -> { joins(:comments).where.not(comments: { id: nil }) }
  has_many :sorted_comments, -> { order(id: :desc) }, class_name: "Comment"

  class << self
    def comments_by_thread
      comments_by_thread = {}
      thread_with_comments.includes(:comments).find_each do |thread|
        comments_by_thread[thread.id] = {
          number_of_comments: thread.comments_count,
          comment_ids: thread.comments.pluck(:id)
        }
      end
      comments_by_thread
    end

    def latest_comments_per_thread
      result = {}
      ThreadPost.includes(:sorted_comments).find_each do |thread|
        result[thread.id] = thread.sorted_comments.first(3)
      end
      result
    end

    def most_popular_comments_per_thread
      comments = Comment
        .select("comments.*, COUNT(votes.id) as votes_count")
        .joins(:votes)
        .group("comments.id")
        .order("comments.thread_post_id, votes_count DESC")

      # Group by thread_post_id and pick top 3 for each
      comments.group_by(&:thread_post_id).transform_values { |arr| arr.first(3) }
    end
  end
end
