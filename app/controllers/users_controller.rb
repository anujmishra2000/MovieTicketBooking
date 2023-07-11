class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def set_user
    @user = current_user
    redirect_to root_path, alert: t('.not_exist') if @user.nil?
  end
end
