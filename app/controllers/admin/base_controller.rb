class Admin::BaseController < ApplicationController
  before_action :ensure_user_is_admin
  layout "admin"

  def ensure_user_is_admin
    unless current_user.admin?
      redirect_to store_front_movies_path, notice: t(:denied_privilege)
    end
  end
end
