class MoviesController < ApplicationController
  def index
    @featured = Movie.all.sample
    @lists = List.all
  end

  def show
    @movie = Movie.find(params[:id])
  end
end

private

def movie_params
  params.require(:movie).permit(:title)
end
