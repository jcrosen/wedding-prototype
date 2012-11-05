class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :scheduled_date
      t.string :location

      t.timestamps
    end
  end
end
