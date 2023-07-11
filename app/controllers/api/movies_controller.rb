module Api
  class MoviesController < Api::BaseController
    def index
      @q = Movie.ransack(params[:q])
      @q.status_eq =  Movie.statuses[params[:status]] if params[:status].present?
      @q.title_cont = params[:title] if params[:title].present?
      @movies = @q.result
      render json: @movies, each_serializer: MovieSerializer
    end
  end
end
