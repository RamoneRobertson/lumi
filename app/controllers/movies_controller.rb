class MoviesController < ApplicationController
  def index
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
