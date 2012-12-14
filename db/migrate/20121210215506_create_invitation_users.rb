class CreateInvitationUsers < ActiveRecord::Migration
  def change
    create_table :invitation_users do |t|
      t.integer :user_id
      t.integer :invitation_id
      t.string :role

      t.timestamps
    end
  end
end
