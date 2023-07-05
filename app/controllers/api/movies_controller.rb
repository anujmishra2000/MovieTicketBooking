module Api
  class MoviesController < Api::BaseController

    def index
      @movies = Movie.all
      @movies = @movies.where(status: params[:status]) if params[:status]
      @movies = @movies.where("lower(title) LIKE ?", "%" + Movie.sanitize_sql_like(params[:title]) + "%") if params[:title]
      render json: @movies, each_serializer: MovieSerializer
    end
  end
end
