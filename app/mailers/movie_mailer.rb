class MovieMailer < ApplicationMailer
  def notify_upcoming
    @upcoming_movies = Movie.upcoming
    @upcoming_movies.each do |movie|
      attachments.inline["#{movie.id}.jpg"] = movie.poster.download
    end
    customer_emails = User.customer.pluck(:email)
    mail(bcc: customer_emails, subject: 'Upcoming Movies')
  end
end
