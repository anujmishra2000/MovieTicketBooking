class Admin::BaseController < ApplicationController
  before_action :ensure_user_is_admin

  def ensure_user_is_admin
    unless current_user.admin?
      redirect_to movie_index_path, notice: t('.denied_privilege')
    end
  end
end