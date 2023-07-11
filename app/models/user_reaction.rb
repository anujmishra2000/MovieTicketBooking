class UserReaction < ApplicationRecord
  belongs_to :reactable, polymorphic: true
  belongs_to :user

  after_commit :broadcast_reaction

  enum status: {
    'up_vote': 0,
    'down_vote': 1
  }

  def self.liked_by_user?(user)
    up_vote.exists?(user: user)
  end

  def self.disliked_by_user?(user)
    down_vote.exists?(user: user)
  end

  def self.total_likes
    up_vote.count
  end

  def self.total_dislikes
    down_vote.count
  end

  private def broadcast_reaction
    ActionCable.server.broadcast('reactions_channel', { total_likes: reactable.user_reactions.total_likes, total_dislikes: reactable.user_reactions.total_dislikes, reacted_by: user_id, action: status, reactable_type: reactable_type, reactable_id: reactable_id })
  end
end
