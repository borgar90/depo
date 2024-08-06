# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "borgar-sin-bookstore.com",
    authentication: "plain",
    user_name: "borgar90",
    password: "rarr kkcd nuwo adig",
    enable_starttls_auto: true
  }
end