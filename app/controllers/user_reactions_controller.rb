class UserReactionsController < ApplicationController
  before_action :set_reactable, only: [:up_vote, :down_vote]

  def up_vote
    @reaction = current_user.reactions.find_or_initialize_by(reactable: @reactable)
    if @reaction.persisted?
      @reaction.up_vote? ? @reaction.destroy : @reaction.up_vote!
    else
      @reaction.up_vote!
    end
  end

  def down_vote
    @reaction = current_user.reactions.find_or_initialize_by(reactable: @reactable)
    if @reaction.persisted?
      @reaction.down_vote? ? @reaction.destroy : @reaction.down_vote!
    else
      @reaction.down_vote!
    end
  end

  private def set_reactable
    model = params[:reactable_type].constantize
    @reactable = model.find_by(id: params[:id])
    return unless @reactable.nil?
    redirect_to movies_path, alert: t('.not_exist', model: model)
  end
end
