class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('notification@example.com', 'Movie Booking App')
  layout "mailer"
end
