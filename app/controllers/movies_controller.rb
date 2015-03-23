# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    # variables
    puts params
    @hilite = "hilite"
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @checked_ratings = @all_ratings
    doRedirect = false
    # for sorting on title and date
    # case3 = if nothing set, doesnt do anything
    if (params.has_key?(:sort_by) || session.has_key?(:sort_by))
      # case1 = session set, param not set
      if (session.has_key?(:sort_by) && !params.has_key?(:sort_by))
        params[:sort_by] = session[:sort_by]
        doRedirect = true
      # case 2 = both set, set session to params
      elsif (session.has_key?(:sort_by) && params.has_key?(:sort_by))
        session[:sort_by] = params[:sort_by]
      end
      
      if not doRedirect
        if params[:sort_by] == "title"
          @movies.sort_by! {|obj| obj.title}
        elsif params[:sort_by] == "release_date"
          @movies.sort_by! {|obj| obj.release_date}
        end
      end
    end
    session[:sort_by] = params[:sort_by]

    # for filtering on ratings
    # case3 = if nothing set, doesnt do anything
    if (params.has_key?(:ratings) || session.has_key?(:ratings))
      # case1 = session set, param not set
      if (session.has_key?(:ratings) && !params.has_key?(:ratings))
        params[:ratings] = session[:ratings]
        doRedirect = true
      # case 2 = both set, set session to params
      elsif (session.has_key?(:ratings) && params.has_key?(:ratings))
        session[:ratings] = params[:ratings]
      end

      if not doRedirect
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
    session[:ratings] = params[:ratings]

    if doRedirect
      flash.keep
      redirect_to :action => 'index', :ratings => session[:ratings], :sort_by => params[:sort_by]
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
