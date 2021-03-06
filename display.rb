# display.rb
# scrapes IMDB for all movies currently showing in theaters
# and displays their associated average cast member age

require_relative 'cast_member'
require_relative 'movie'
require_relative 'IMDB_Scraper'
require 'command_line_reporter'

class Display
  include CommandLineReporter

  # runs IMDB_Scaper and displays the results
  def run
    min_cast_member_number = 3

    imdb_scraper = IMDB_Scraper.new
    movies = imdb_scraper.get_cast_list_for_each_movie(imdb_scraper.get_movies_in_theaters)
    puts

    header(:title => 'Average Age of the Cast Members of Movies Currently in Theaters',
           :width => 100, :bold => true)

    table(:border => true) do
      sum_age = 0
      sum_rating = 0
      movie_count = 0
      rating_count = 0
      row  do
        column 'Title',       :width => 40, :align => 'center'
        column 'Average Age', :width => 25, :padding => 2
        column 'Metascore',   :width => 30, :padding => 2
      end

      movies.each do |movie|
        movie.average_age = movie.calculate_average_age

        # skips the movie if the minimum cast_member number is not met
        if movie.cast_list.count < min_cast_member_number
          next
        end
        row do
          column movie.title
          column movie.average_age
          column movie.score
        end
        sum_age += movie.average_age
        movie_count += 1

        puts movie.score.class
        puts movie.score.length
        puts movie.score
        puts

        # if there is no score available
        if (movie.score.length > 3)
          next
        end

        rating_count += 1
        sum_rating += movie.score.to_i
      end 

      average_age_all_movies = sum_age/movie_count
      average_score = sum_rating/rating_count
      row do
        column 'Average Age and Score of All Movies'
        column average_age_all_movies
        column average_score
      end
    end
  end
end
Display.new.run