class Vote < ApplicationRecord
  belongs_to :voter, class_name: "User"
  belongs_to :votable, polymorphic: true

  validates :voter_id, uniqueness: { scope: [ :votable_type, :votable_id ] }
end
