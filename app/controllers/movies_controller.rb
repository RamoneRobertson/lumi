class MoviesController < ApplicationController
  def index
    @lists = List.all
  end
end
