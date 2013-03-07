namespace :app do

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nSorry but this task should not be executed against the production environment"
    end
  end

  task ensure_production_environment: :environment do
    if !Rails.env.production?
      raise "\nSorry but this task should only be executed against the production environment"
    end
  end
  
  desc "Reset"
  task :reset => [:ensure_development_environment, "db:migrate:reset", "db:seed", "app:populate_dev"]

  desc "Seed the production environment with base data if it doesn't already exist"
  task seed_production: [:ensure_production_environment, :environment] do
    require 'miniskirt'
  end

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
    friend_of_friend = Factory.create(:user, email: "friend_of_friend@wedding.com", display_name: "Friend of Friend", password: "please", password_confirmation: "please")
    
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
      planner_wine_tour_inv = Factory.create(:invitation, event_id: wine_tour.id)
      planner_scavenger_hunt_inv = Factory.create(:invitation, event_id: scavenger_hunt.id)
      planner_picnic_inv = Factory.create(:invitation, event_id: picnic.id)
      planner_rehearsal_dinner_inv = Factory.create(:invitation, event_id: rehearsal_dinner.id)
      planner_ceremony_inv = Factory.create(:invitation, event_id: ceremony.id)
      planner_reception_inv = Factory.create(:invitation, event_id: reception.id)
      
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_wine_tour_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_scavenger_hunt_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_picnic_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_rehearsal_dinner_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_ceremony_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: planner.id, invitation_id: planner_reception_inv.id, role: 'owner') 
      
      # Family is invited to everything other than the wine tour (unless they're a close friend as well, this is just a blanket category)
      family_scavenger_hunt_inv = Factory.create(:invitation, event_id: scavenger_hunt.id)
      family_picnic_inv = Factory.create(:invitation, event_id: picnic.id)
      family_rehearsal_dinner_inv = Factory.create(:invitation, event_id: rehearsal_dinner.id)
      family_ceremony_inv = Factory.create(:invitation, event_id: ceremony.id)
      family_reception_inv = Factory.create(:invitation, event_id: reception.id)
      
      Factory.create(:guest, user_id: family.id, invitation_id: family_scavenger_hunt_inv.id, role: 'owner')
      Factory.create(:guest, user_id: family.id, invitation_id: family_picnic_inv.id, role: 'owner')
      Factory.create(:guest, user_id: family.id, invitation_id: family_rehearsal_dinner_inv.id, role: 'owner')
      Factory.create(:guest, user_id: family.id, invitation_id: family_ceremony_inv.id, role: 'owner')
      Factory.create(:guest, user_id: family.id, invitation_id: family_reception_inv.id, role: 'owner')
      
      # Close Friends are invited to everything
      close_friend_wine_tour_inv = Factory.create(:invitation, event_id: wine_tour.id)
      close_friend_scavenger_hunt_inv = Factory.create(:invitation, event_id: scavenger_hunt.id)
      close_friend_picnic_inv = Factory.create(:invitation, event_id: picnic.id)
      close_friend_rehearsal_dinner_inv = Factory.create(:invitation, event_id: rehearsal_dinner.id)
      close_friend_ceremony_inv = Factory.create(:invitation, event_id: ceremony.id)
      close_friend_reception_inv = Factory.create(:invitation, event_id: reception.id)
      
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_wine_tour_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_scavenger_hunt_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_picnic_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_rehearsal_dinner_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_ceremony_inv.id, role: 'owner') 
      Factory.create(:guest, user_id: close_friend.id, invitation_id: close_friend_reception_inv.id, role: 'owner') 
      
      # Friends are invited to everything except the wine tour and rehearsal dinner
      friend_scavenger_hunt_inv = Factory.create(:invitation, event_id: scavenger_hunt.id)
      friend_picnic_inv = Factory.create(:invitation, event_id: picnic.id)
      friend_ceremony_inv = Factory.create(:invitation, event_id: ceremony.id)
      friend_reception_inv = Factory.create(:invitation, event_id: reception.id)
      
      Factory.create(:guest, user_id: friend.id, invitation_id: friend_scavenger_hunt_inv.id, role: 'owner')
      Factory.create(:guest, user_id: friend.id, invitation_id: friend_picnic_inv.id, role: 'owner')
      Factory.create(:guest, user_id: friend.id, invitation_id: friend_ceremony_inv.id, role: 'owner')
      Factory.create(:guest, user_id: friend.id, invitation_id: friend_reception_inv.id, role: 'owner')
      
      Factory.create(:guest, user_id: friend_of_friend.id, invitation_id: friend_reception_inv.id, role: 'viewer')
      Factory.create(:guest, user_id: friend_of_friend.id, invitation_id: friend_picnic_inv.id, role: 'viewer')
      Factory.create(:guest, user_id: friend_of_friend.id, invitation_id: friend_ceremony_inv.id, role: 'viewer')
      
  
    # Make blog posts
    post_raw_bodies = [
      {
        user_id: admin.id,
        postable: scavenger_hunt,
        published_date: Time.now,
        title: "Scavenger Hunt Details",
        body: "# What to expect\n\nPlease plan on bringing some amount of rain appropriate gear (water-friendly shoes, a light rain jacket, etc.); we'll provide plenty of umbrellas at the starting area.  You'll need someone with a camera of some kind (camera phone is fine) to take pictures of each scavenger hunt item.\n\nFinally, the list can be found at the following link: [localdoc](local-doc.html)"
      },
      
      {
        user_id: admin.id,
        postable: nil,
        published_date: Time.new - 5,
        title: "Quick Markdown Example",
        body:
"An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, `monospace`. Itemized lists look like:

  * this one
  * that one
  * the other one

Note that --- not considering the asterisk --- the actual text content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex. \"it's all in chapters 12--14\"). Three dots ... will be converted to an ellipsis.



An h2 header
------------

Here's a numbered list:

 1. first item
 2. second item
 3. third item

Note again how the actual text starts at 4 columns in (4 characters from the left side). Here's a code sample:

    # Let me re-iterate ...
    for i in 1 .. 10 { do-something(i) }

As you probably guessed, indented 4 spaces. 

### An h3 header ###

Now a nested list:

1. First, get these ingredients:
  * carrots
  * celery
  * lentils

2. Boil some water.

3. Dump everything in the pot and follow this algorithm:

    find wooden spoon
    uncover pot
    stir
    cover pot
    balance wooden spoon precariously on pot handle
    wait 10 minutes
    goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including that last line which continues item 3 above). Here's a link to [a website](http://foo.bar). Here's a link to a [localdoc](local-doc.html).

Tables can look like this:

size  material      color
----  ------------  ------------
9     leather       brown
10    hemp canvas   natural
11    glass         transparent

Table: Shoes, their sizes, and what they're made of

(The above is the caption for the table.) Here's a definition list:

apples
  : Good for making applesauce.
oranges
  : Citrus!
tomatoes
  : There's no \"e\" in tomatoe.

Again, text is indented 4 spaces. (Alternately, put blank lines in between each of the above definition list lines to spread things out more.)

Done."
        
      }
]
    
    post_raw_bodies.each do |_post|
      Factory.create(:post, title: _post[:title], user_id: _post[:user_id], published_at: _post[:published_date], postable: _post[:postable], raw_body: _post[:body])
    end
    
  end

end
