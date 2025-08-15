class User < ApplicationRecord
  has_secure_password
  has_many :threads, class_name: "ThreadPost", foreign_key: "user_id", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, foreign_key: :voter_id, dependent: :destroy
  has_many :saveds, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
