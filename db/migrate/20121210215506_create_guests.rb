class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :user_id
      t.integer :invitation_id
      t.string :role
      t.string :first_name
      t.string :last_name
      t.string :display_name

      t.timestamps
    end
  end
end
