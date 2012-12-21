ActionMailer::Base.smtp_settings = {
  :address              => ENV["MAILER_ADDRESS"] || "localhost",
  :port                 => ENV["MAILER_PORT"] || 1025,
  :domain               => ENV["MAILER_DOMAIN"] || "wedding.com",
  :user_name            => ENV["MAILER_USER"] || "user",
  :password             => ENV["MAILER_PASSWORD"] || "secret",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

