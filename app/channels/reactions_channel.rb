class ReactionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reactions_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
