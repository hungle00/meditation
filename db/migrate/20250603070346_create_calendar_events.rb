class CreateCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_events do |t|
      t.datetime :occurs_at
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
