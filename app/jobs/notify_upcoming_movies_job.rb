class NotifyUpcomingMoviesJob < ApplicationJob
  def perform
    MovieMailer.notify_upcoming.deliver_later
  end
end
