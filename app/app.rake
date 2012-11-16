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
    admin = Factory.build(:user, email: "admin@wedding.com", display_name: "Administrator", password: "please", password_confirmation: "please")
    admin.make_admin
    admin.save
    
    #Make three general users
    planner = Factory.create(:user, email: "planner@wedding.com", display_name: "Planner", password: "please", password_confirmation: "please")
    family = Factory.create(:user, email: "family@wedding.com", display_name: "Family Member", password: "please", password_confirmation: "please")
    close_friend = Factory.create(:user, email: "close-friend@wedding.com", display_name: "Close Friend", password: "please", password_confirmation: "please")
    friend = Factory.create(:user, email: "friend@wedding.com", display_name: "Friend", password: "please", password_confirmation: "please")
    
    #Make six events with one public event
    wine_tour = Factory.create(:event, title: "Wine Tour", 
                                       description: "Join the bride and groom for a trip through Oregon's famous Dundee Hills and taste many of the areas best wines. Adults only please!", 
                                       location: "Pioneer Square, Portland, OR", 
                                       scheduled_date: "June 06, 2013 6:00pm")
                                       
    scavenger_hunt = Factory.create(:event, title: "Scavenger Hunt", 
                                       description: "Join us downtown for a Portland-themed scavenger hunt! We'll start at Pioneer Square and will end the hunt at the Welcome Picnic in the park! Be sure to bring weather appropriate attire, umbrellas will be provided if you need them.", 
                                       location: "Pioneer Square, Portland, OR", 
                                       scheduled_date: "June 07, 2013 10:00am")
                                       
    picnic = Factory.create(:event, title: "Welcome Lunch", 
                                       description: "Join us for lunch at historic Couch City Park. We'll have ample food and drink, and room for lawn games (weather permitting). Hope to see you there!", 
                                       location: "Couch City Park, NW Glisan St, Portland, OR, 97209", 
                                       scheduled_date: "June 07, 2013 12:30pm")
                                       
    rehearsal_dinner = Factory.create(:event, title: "Rehearsal Dinner", 
                                       description: "Come join the bride and groom for a rehearsal dinner at Bernie's Bistro in NE Portland", 
                                       location: "Bernie's Bistro, 2904 NE Alberta St, Portland, OR, 97211", 
                                       scheduled_date: "June 07, 2013 6:00pm")
                                       
    ceremony = Factory.create(:event, title: "Ceremony",
                                       description: "Please join us for the \"formal\" ceremony where we symbolically join the already happy couple! It will include both traditional and less ordinary events so you won't want to miss it.", 
                                       location: "Castaway, 1900 NW 18th Ave, Portland, OR, 97209", 
                                       scheduled_date: "June 08, 2013 5:30pm",
                                       is_public: true)
                                       
    reception = Factory.create(:event, title: "Reception",
                                       description: "If you make only one event this wedding make this the one! We'll have games, dancing, food, drink, and lots of fun. The reception is indoors and will be heated, but bring a jacket just in case you want to step outside!", 
                                       location: "Castaway, 1900 NW 18th Ave, Portland, OR, 97209", 
                                       scheduled_date: "June 08, 2013 6:30pm",
                                       is_public: true)
    
    #Make invitations for the events across different users
      # Planner is invited to all events
      Factory.create(:invitation, user_id: planner.id, event_id: wine_tour.id)
      Factory.create(:invitation, user_id: planner.id, event_id: scavenger_hunt.id)
      Factory.create(:invitation, user_id: planner.id, event_id: picnic.id)
      Factory.create(:invitation, user_id: planner.id, event_id: rehearsal_dinner.id)
      Factory.create(:invitation, user_id: planner.id, event_id: ceremony.id)
      Factory.create(:invitation, user_id: planner.id, event_id: reception.id)
      
      # Family is invited to everything other than the wine tour (unless they're a close friend as well, this is just a blanket category)
      Factory.create(:invitation, user_id: family.id, event_id: scavenger_hunt.id)
      Factory.create(:invitation, user_id: family.id, event_id: picnic.id)
      Factory.create(:invitation, user_id: family.id, event_id: rehearsal_dinner.id)
      Factory.create(:invitation, user_id: family.id, event_id: ceremony.id)
      Factory.create(:invitation, user_id: family.id, event_id: reception.id)
      
      # Close Friends are invited to everything
      Factory.create(:invitation, user_id: close_friend.id, event_id: wine_tour.id)
      Factory.create(:invitation, user_id: close_friend.id, event_id: scavenger_hunt.id)
      Factory.create(:invitation, user_id: close_friend.id, event_id: picnic.id)
      Factory.create(:invitation, user_id: close_friend.id, event_id: rehearsal_dinner.id)
      Factory.create(:invitation, user_id: close_friend.id, event_id: ceremony.id)
      Factory.create(:invitation, user_id: close_friend.id, event_id: reception.id)
      
      # Friends are invited to everything except the wine tour and rehearsal dinner
      Factory.create(:invitation, user_id: friend.id, event_id: scavenger_hunt.id)
      Factory.create(:invitation, user_id: friend.id, event_id: picnic.id)
      Factory.create(:invitation, user_id: friend.id, event_id: ceremony.id)
      Factory.create(:invitation, user_id: friend.id, event_id: reception.id)
    
  end

end
