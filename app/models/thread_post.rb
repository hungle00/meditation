class ThreadPost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :thread_with_comments, -> { joins(:comments).where.not(comments: { id: nil }) }

  class << self
    def comments_by_thread
      comments_by_thread = {}
      thread_with_comments.includes(:comments).find_each do |thread|
        comments_by_thread[thread.id] = {
          number_of_comments: thread.comments_count,
          comment_ids: [ thread.comments.pluck(:id) ]
        }
      end
      comments_by_thread
    end
  end
end
