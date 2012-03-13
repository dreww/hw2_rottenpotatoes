class Movie < ActiveRecord::Base

  def self.all_ratings
    all_ratings = Movie.select(:rating).order('rating asc')
  end

end
