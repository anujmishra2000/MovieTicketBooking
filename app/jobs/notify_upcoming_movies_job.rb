class NotifyUpcomingMoviesJob < ApplicationJob
  def perform
    users = User.where(upcoming_movies_alert: true)
    users.find_each do |user|
      MovieMailer.with(user: user).notify_upcoming.deliver_later
    end
  end
end
