class UserReaction < ApplicationRecord
  belongs_to :reactable, polymorphic: true
  belongs_to :user

  after_commit :broadcast_reaction

  enum status: {
    'up_vote': 0,
    'down_vote': 1
  }

  private def broadcast_reaction
    ActionCable.server.broadcast('reactions_channel', { total_likes: reactable.total_likes, total_dislikes: reactable.total_dislikes, reacted_by: user_id, action: status })
  end
end
