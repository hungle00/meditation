class CreateThreadPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :thread_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
