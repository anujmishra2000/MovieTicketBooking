class MovieMailer < ApplicationMailer
  def notify_upcoming
    @upcoming_movies = Movie.upcoming
    @upcoming_movies.each do |movie|
      attachments.inline["#{movie.id}.jpg"] = movie.poster.download
    end
    user = params[:user]
    mail to: user.email, subject: 'Upcoming Movies'
  end
end
