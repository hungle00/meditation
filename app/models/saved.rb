class Saved < ApplicationRecord
  self.table_name = "saved"

  belongs_to :user
  belongs_to :savable, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :savable_type, :savable_id ] }
end
