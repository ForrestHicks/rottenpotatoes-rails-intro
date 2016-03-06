class MoviesController < ApplicationController
  
  @sort = ""

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.uniq.pluck(:rating)
    
    if params[:ratings].present?
      @user_ratings = Movie.where(rating: params[:ratings].keys)
      @rating_settings = params[:ratings]
    end
    
    if params[:sort].present?
      @sort = params[:sort]
    end
    
    if @sort
      @movie = Movie.order(@sort)
      if @user_ratings
        @movie = @movie.where(rating: @rating_settings.keys) if params[:ratings].present?
      end
    elsif @user_ratings
      @movie = Movie.where(rating: @rating_settings.keys) if params[:ratings].present?
    else
      @movie = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
