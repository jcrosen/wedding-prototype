# Random string generator to be used as a helper for factories
class RandomString
  CHARS = [('a'..'z').to_a, ('A'..'Z').to_a, '1234567890'.split].flatten

  def self.generate(size = 6)
    (1..size).inject("") { |s, x| s << CHARS[rand(CHARS.size)] }
  end
end

Factory.define :user, class: User do |u|
  u.display_name "user:#{RandomString.generate(4)}"
  u.email "%{display_name}@wedding.com"
  u.password u.password_confirmation('please')
end

Factory.define :admin, class: User do |a|
  a.display_name "admin%d"
  a.email "%{display_name}@wedding.com"
  a.password a.password_confirmation('pleaseadmin')
end

Factory.define :event, class: Event do |e|
  e.title "Event Title %d"
  e.description "%{title} Description - Longer than the title"
  e.scheduled_date { Time.new }
  e.location "#{RandomString.generate(4)} Anywhere St, Portland, OR"
end

Factory.define :invitation, class: Invitation do |i|
  i.email "#{RandomString.generate(10)}@someemail.com"
  i.status { rand() > 0.5 ? (rand() > 0.5 ? "Attending" : "Not Attending") : "Not Confirmed" }
  i.event_id { Factory.create(:event).id }
  i.sent_date { Time.new }
  i.respond_date { rand() > 0.5 ? Time.new : nil }
  i.party_size "#{rand() * 10}"
end
