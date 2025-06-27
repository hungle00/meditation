class User < ApplicationRecord
  has_many :threads, class_name: "ThreadPost", foreign_key: "user_id", dependent: :destroy
end
