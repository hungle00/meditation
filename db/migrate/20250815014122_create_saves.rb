class CreateSaves < ActiveRecord::Migration[8.0]
  def change
    create_table :saved do |t|
      t.references :user, null: false, foreign_key: true
      t.references :savable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
