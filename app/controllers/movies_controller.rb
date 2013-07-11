class MoviesController < ApplicationController
  # GET
  # /movies/search
  # movies_search path
  def search
    if params[:movie]
      @movies = Imdb::Search.new(params[:movie]).movies[0..9]
    end
      render "index"
  end

  # GET
  def show
    @movie = Imdb::Movie.new(params[:id])
  end

  def save
    @movie = Imdb::Movie.new(params[:id])
    movie = Movie.new
    movie.title = @movie.title
    movie.year = @movie.year
    movie.plot = @movie.plot
    movie.mpaa_rating = @movie.mpaa_rating
    movie.rating = params[:rating]
    movie.save
    redirect_to saved_path

    actors = @movie.cast_members[0..2]
    actors.each do |actor|
      new_actor = Actor.find_or_create_by_name(actor)

     movie.actors << new_actor
    end
  end

  def saved
    @movies = Movie.where('rating < ?', 100)
  end

  def favorites
    @movies = Movie.where(rating: 100)
    render 'saved'
  end
end




