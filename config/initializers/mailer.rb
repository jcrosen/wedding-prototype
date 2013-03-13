ActionMailer::Base.mailgun_settings = {
  api_key: ENV["MAILGUN_API_KEY"],
  api_domain: ENV["MAILGUN_API_DOMAIN"]
}