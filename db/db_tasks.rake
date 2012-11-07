namespace :app do

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nSorry but this task should not be executed against the production environment"
    end
  end

  desc "Reset"
  task :reset => [:ensure_development_environment, "db:migrate:reset", "db:seed", "app:populate_dev"]

  desc "Load the development environment"
  task :populate_dev => [:ensure_development_environment, :environment] do
    require 'miniskirt'
    require_relative '../spec/factories/factories'
    
    #Make an admin user
    admin = Factory.build(:user)
    admin.make_admin
    admin.save
    
    #Make three general users
    user1 = Factory.create(:user, password: "please", password_confirmation: "please")
    user2 = Factory.create(:user, password: "please", password_confirmation: "please")
    user3 = Factory.create(:user, password: "please", password_confirmation: "please")
    
    #Make six events with one public event
    event1 = Factory.create(:event)
    event2 = Factory.create(:event)
    event3 = Factory.create(:event)
    event4 = Factory.create(:event)
    event5 = Factory.create(:event)
    event6 = Factory.create(:event, is_public: true)
    
    #Make invitations for the events across different users
      # User 1 is invited to all events
      inv_user_1_event_1 = Factory.create(:invitation, user_id: user1.id, event_id: event1.id)
      inv_user_1_event_2 = Factory.create(:invitation, user_id: user1.id, event_id: event2.id)
      inv_user_1_event_3 = Factory.create(:invitation, user_id: user1.id, event_id: event3.id)
      inv_user_1_event_4 = Factory.create(:invitation, user_id: user1.id, event_id: event4.id)
      inv_user_1_event_5 = Factory.create(:invitation, user_id: user1.id, event_id: event5.id)
      
      # User 2 is invited to three events
      inv_user_2_event_1 = Factory.create(:invitation, user_id: user2.id, event_id: event1.id)
      inv_user_2_event_3 = Factory.create(:invitation, user_id: user2.id, event_id: event3.id)
      inv_user_2_event_4 = Factory.create(:invitation, user_id: user2.id, event_id: event4.id)
      
      # User 3 is invited to two events
      inv_user_3_event_1 = Factory.create(:invitation, user_id: user3.id, event_id: event1.id)
      inv_user_3_event_4 = Factory.create(:invitation, user_id: user3.id, event_id: event4.id)
    
  end

end
