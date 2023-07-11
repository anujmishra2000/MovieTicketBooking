module Api
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!

    private def authorize_api_user
      @user = User.find_by(auth_token: params[:token])
      render json: { error: 'Unauthorized Api User' }, status: 401 if @user.nil?
    end
  end
end
