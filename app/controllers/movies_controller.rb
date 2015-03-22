# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    # variables
    puts params
    @hilite = "hilite"
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = @all_ratings
    
    # for sorting on title and date
    if (params.has_key?(:sort_by))
      if params[:sort_by] == "title"
        @movies.sort_by! {|obj| obj.title}
      elsif params[:sort_by] == "release_date"
        @movies.sort_by! {|obj| obj.release_date}
      end
    end

    # for filtering on ratings
    if (params.has_key?(:ratings))
      ratings_temp = params[:ratings]
      ratings = []
      for x in ratings_temp do
        ratings.append(x[0].to_s)
      end
      @checked_ratings = ratings
      ratings_filtered_movies = Movie.find_all_by_rating(ratings)
      @movies = @movies & ratings_filtered_movies
    end
  
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
