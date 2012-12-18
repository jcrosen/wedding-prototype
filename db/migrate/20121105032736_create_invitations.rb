class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :status
      t.integer :event_id
      t.datetime :sent_at
      t.datetime :confirmed_at
      t.integer :max_party_size

      t.timestamps
    end
  end
end
