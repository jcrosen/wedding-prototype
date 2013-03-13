require "action_mailer"
require "active_support"
require "rest-client"

module Mailgun

  class DeliveryError < StandardError
  end

  class DeliveryMethod
    include ActionView::Helpers::SanitizeHelper

    attr_accessor :settings

    def initialize(settings)
      self.settings = settings
    end

    def api_domain
      self.settings[:api_domain] || ENV["MAILGUN_API_DOMAIN"]
    end

    def api_key
      self.settings[:api_key] || ENV['MAILGUN_API_KEY']
    end

    def api_url
      "https://api:#{self.api_key}@api.mailgun.net/v2/#{self.api_domain}/messages"
    end

    def deliver!(mail)
      if self.api_key.nil? or self.api_domain.nil?
        raise Mailgun::DeliveryError.new("Mailgun settings are not valid!")
      end

      recipients = mail.to
      data = {}

      from = mail.from.first
      subject = mail.subject
      text = (mail.text_part.body if mail.text_part) || (strip_tags(mail.body.to_s) if mail.body)
      html = (mail.html_part.body if mail.html_part) || (mail.body.to_s if mail.body)

      print "html part: #{mail.html_part}"
      print "text_part: #{mail.text_part}"
      print "body: #{mail.body}"

      recipients.each do |to|
        print "Sending the following data:\n"
        print "to: #{to}\n"
        print "from: #{from}\n"
        print "subject: #{subject}\n"
        print "text: #{text}\n"
        print "html: #{html}\n"

        response = RestClient.post self.api_url,
          to: to,
          from: from,
          subject: subject,
          text: text,
          html: html

        print "\n\nResponse: #{response}"
        print "\n\nResponse Body: #{response.body}"

        if response.code != 200
          raise Mailgun::DeliveryError.new(response['message'] || "Unknown mailgun error")
        end
      end

    end

  end

end
