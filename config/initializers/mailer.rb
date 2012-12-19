ActionMailer::Base.smtp_settings = {
  :address              => ENV["MAILER_ADDRESS"],
  :port                 => ENV["MAILER_PORT"],
  :domain               => ENV["MAILER_DOMAIN"],
  :user_name            => ENV["MAILER_USER"],
  :password             => ENV["MAILER_PASSWORD"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

