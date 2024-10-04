require 'json'
puts "========== Clearing the database =========="
List.destroy_all
User.destroy_all
Movie.destroy_all

@tmdb_ids = Hash.new
@languages = ["ja", "vi", "ko", "zh", "hi", "es", "fr", "ar", "bn", "ru", "pt", "ur", "de"]
motn_token = ENV["MOTN_KEY"]
tmdb_token = ENV["TMDB_KEY"]
tmdb_api_key = "?api_key=#{tmdb_token}"

# ENDPOINTS for TMDB
base_tmdb_endpoint = "https://api.themoviedb.org/3/movie/"
genres_tmdb_endpoint = "https://api.themoviedb.org/3/genre/movie/list?api_key=#{tmdb_token}"
discover_tmdb_endpoint = "https://api.themoviedb.org/3/discover/movie"

def api_call(url)
  api_data = URI.open(url).read
  JSON.parse(api_data)
end

def create_movie(movie_info)
  # title = movie_info["title"] if @tmdb_ids.has_value?(movie_info["title"]) == false
  collection = movie_info["belongs_to_collection"]["id"] if movie_info["belongs_to_collection"] != nil
  studio = movie_info["production_companies"][0]["id"] if movie_info["production_companies"].empty? == false
  poster =  "https://image.tmdb.org/t/p/original" + movie_info["poster_path"] if movie_info["poster_path"] != nil

  puts "==============================================="
  puts "Creating movie: #{movie_info["title"]}"
  movie = Movie.new(title: movie_info["title"],
                    overview: movie_info["overview"],
                    rating: movie_info["vote_average"],
                    runtime: movie_info["runtime"],
                    poster_url: poster,
                    release_date: movie_info["release_date"],
                    tmdb_id: movie_info["id"],
                    imdb_id: movie_info["imdb_id"],
                    collection_id: collection,
                    production_company_id: studio
                    )

  # Add genre tags
  puts
  movie_info["genres"].each do |genre|
    puts "genre_tag: #{genre["name"]}"
    movie.genre_list.add(genre["name"])
  end
  puts

  # Add language tags
  languages = movie_info["spoken_languages"]
  languages.each do |lang|
    puts "language_tag: #{lang["english_name"]}"
    movie.language_list.add(lang["english_name"].downcase)
  end
  puts


  movie.save!
  puts
  puts "TMDB ID: #{movie_info["id"]}"
  puts "COLLECTION ID: #{collection}"
  puts "STUDIO ID: #{studio}"
  puts "POSTER URL: #{poster}"
  puts
  puts
end

def add_movie_ids(movie_data, category=nil)
  movie_data["results"].each do |movie|
    puts "==============================================="
    puts "Adding #{movie["id"]}: #{movie["title"]} to hash file"
    @tmdb_ids[movie["id"]] = movie["title"] if @tmdb_ids.key?(movie["id"]) == false
    puts "COUNT: #{@tmdb_ids.count}"
    puts
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
  puts "==============================================="
  puts "Creating new list: #{category}"
  List.create!(name: category)
  puts
end

# ===============================================
# GET MOVIES IDS
# ===============================================

# Get ids of all movies from each Genre
page = 0
genres_data["genres"].each do |genre|
  1.times do
    page += 1
    movies_data = api_call(discover_tmdb_endpoint + "?api_key=#{tmdb_token}&include_adult=false&with_genres=#{genre["id"]}&page=#{page}")
    add_movie_ids(movies_data)
  end
end

# Get ids from now_playing, top_rated, and upcoming movies
%w(now_playing popular top_rated upcoming).each do |category|
  puts "==============================================="
    movies_data = api_call(base_tmdb_endpoint + "#{category}?api_key=#{tmdb_token}")
    add_movie_ids(movies_data, category)
  end

# Get ids from different languages
page = 0
@languages.each do |lang|
  1.times do
    puts "==============================================="
    page += 1
    movies_data = api_call(discover_tmdb_endpoint + "#{tmdb_api_key}&with_original_language=#{lang}&page=#{page}")
    add_movie_ids(movies_data)
  end
end

# ===============================================
# CREATE MOVIES
# ===============================================

@tmdb_ids.each do |movie_id, title|
  movie_data = api_call(base_tmdb_endpoint + "#{movie_id}?api_key=#{tmdb_token}")
  create_movie(movie_data)
end

# ===============================================
# BOOKMARKS CREATION
# ===============================================
