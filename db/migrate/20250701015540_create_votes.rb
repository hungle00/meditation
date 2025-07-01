class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :voter, null: false, foreign_key: { to_table: :users }
      t.references :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
