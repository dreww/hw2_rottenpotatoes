class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    ratings_wanted, sorted_by = params[:ratings], params[:sort_by]

    @all_ratings = Movie.all_ratings.map {|r| r.rating}.uniq
    @movies = []

    if ratings_wanted
      session[:ratings] = ratings_wanted
      fetch_ratings = ratings_wanted.keys
      fetch_ratings.each do |rating|
        Movie.where("rating = ?", rating.to_s).each {|movie| @movies << movie}
      end
    end
    
    @movies = Movie.all if @movies.empty?

    if sorted_by
      session[:sort_by] = sorted_by
      @movies = @movies.sort_by {|movie| movie.send(sorted_by)}
    end

    if session[:ratings] != params[:ratings] || session[:sort_by] != params[:sort_by]
        params[:ratings] ||= session[:ratings]
        params[:sort_by] ||= session[:sort_by]
        redirect_to movies_path(params)
    end

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
