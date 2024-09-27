require 'json'
puts "========== Clearing the database =========="
List.destroy_all
User.destroy_all
Movie.destroy_all

motn_token = ENV["MOTN_KEY"]
tmdb_token = ENV["TMDB_KEY"]

genres_tmdb_endpoint = "https://api.themoviedb.org/3/genre/movie/list?api_key=#{tmdb_token}"
upcoming_tmdb_endpoint = "https://api.themoviedb.org/3/movie/now_playing"
discover_tmdb_endpoint = "https://api.themoviedb.org/3/discover/movie"

def api_call(endpoint)
  api_data = URI.open(endpoint).read
  JSON.parse(api_data)
end

def create_movie(movies_list, genre_name)
  movies_list.each do |movie|
    puts "==============================================="
    puts "Creating movie: #{movie["title"]}"

    movie = Movie.new(title: movie["title"], overview: movie["overview"], rating: movie["vote_average"], runtime: 102)
    movie.genre_list.add(genre_name)
    if Movie.exists?(title: movie["title"]) == false
      movie.save!
    else
      puts "==============================================="
      puts "Adding genre #{genre_name} to #{movie["title"]}"
      movie = Movie.find_by(title: movie["title"])
      movie.genre_list.add(genre_name)
      movie.save!
    end
  end
end

# ===============================================
# LISTS CREATION
# ===============================================

# Create Genre List
genres_data = api_call(genres_tmdb_endpoint)
genres_data["genres"].each do |genre|
  puts "========================"
  puts "Creating new list: #{genre["name"]}"
  List.create!(name: genre["name"].downcase)
  puts
end

# Create Other Lists
puts "=========== OTHER LISTS ============="
%w(now_playing popular top_rated upcoming).each do |category|
  puts "========================"
  puts "Creating new list: #{category}"
  List.create!(name: category)
  puts
end

# ===============================================
# MOVIES CREATION
# ===============================================

# Greate Movies for each Genre
genres_data["genres"].each do |genre|
  movies_data = api_call(discover_tmdb_endpoint + "?api_key=#{tmdb_token}&include_adult=false&with_genres=#{genre["id"]}")
  create_movie(movies_data["results"], genre["name"])
  puts
end

movies = Movie.all

movies.each do |movie|
  puts "Genres for #{movie.title}:"
  puts movie.genre_list
  puts "==============================================="
  puts
end
