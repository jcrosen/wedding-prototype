class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :status
      t.integer :user_id
      t.integer :event_id
      t.datetime :sent_date
      t.datetime :respond_date
      t.integer :party_size

      t.timestamps
    end
  end
end
