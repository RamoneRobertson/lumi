require 'json'
puts "========== Clearing the database =========="
Bookmark.destroy_all
List.destroy_all
User.destroy_all
Movie.destroy_all

@tmdb_ids = Hash.new
@languages = ["ja", "vi", "ko", "zh", "es", "fr", "it", "de"]
motn_token = ENV["MOTN_KEY"]
tmdb_token = ENV["TMDB_KEY"]
tmdb_api_key = "?api_key=#{tmdb_token}"

# ENDPOINTS for TMDB
@base_tmdb_endpoint = "https://api.themoviedb.org/3/movie/"
genres_tmdb_endpoint = "https://api.themoviedb.org/3/genre/movie/list?api_key=#{tmdb_token}"
discover_tmdb_endpoint = "https://api.themoviedb.org/3/discover/movie"
collection_tmdb_endpoint = "https://api.themoviedb.org/3/collection/"

# Makes an API call using an url endpoint
# Returns the response as JSON
def api_call(url)
  begin
    api_data = URI.open(url).read
  rescue OpenURI::HTTPError => e
    puts "API call failed: #{e.message}"
    nil
  end


  JSON.parse(api_data)
end


def create_movie(data, tag_info)
  # Iterate through the response data from the API call (20 movies per API response) - see line 168
  data["results"].each do  |result|

    # Try to get individual movie details
    # endpoint https://api.themoviedb.org/3/movie/[Movie ID]?[API KEY]
    begin
      movie_info = api_call(@base_tmdb_endpoint + "#{result["id"]}?api_key=#{ENV["TMDB_KEY"]}")
    # Check for an HTTP error
    rescue OpenURI::HTTPError => e
      puts "An Error Has Occured. Please View The Details:"
      OpenURI::HTTPError => e
      puts e.message
      next
    end

    # nil/null check for certain properties. Will error out otherwise
    collection_id = movie_info.dig("belongs_to_collection", "id") if movie_info["belongs_to_collection"] != nil
    # studio_id = movie_info.dig("production_companies")[0]["id"] if movie_info["production_companies"].nil? == false || movie_info["title"] == "Taken 2"
    poster_url = "https://image.tmdb.org/t/p/original" + movie_info["poster_path"] if movie_info["poster_path"] != nil
    backdrop_url = "https://image.tmdb.org/t/p/original" + movie_info["backdrop_path"] if movie_info["backdrop_path"] != nil


    puts "==============================================="
    puts "Title: #{movie_info["title"]}"
    puts "TMDB ID: #{movie_info["id"]}"
    puts "Collection ID: #{collection_id}"
    # puts "Studio ID: #{studio_id}"
    puts "Poster Url #{poster_url}"
    puts "Backdrop Url #{backdrop_url}"

    # Create a new Movie record in the DB
    movie = Movie.new(title: movie_info["title"],
                overview: movie_info["overview"],
                rating: movie_info["vote_average"],
                runtime: movie_info["runtime"],
                poster_url: poster_url,
                release_date: movie_info["release_date"],
                tmdb_id: movie_info["id"],
                imdb_id: movie_info["imdb_id"],
                collection_id: collection_id,
                # production_company_id: studio_id,
                backdrop: backdrop_url,
                popularity: movie_info["popularity"]
                )
    # Add genres to genre list
    movie.genre_list = movie_info["genres"].pluck("name").join(",")

    # Save the new Movie record
    movie.save!
    puts
    puts
  end
end


def create_bookmark(list_id, movies)
  movies.each do  |movie|
    puts "==============================================="
    puts "Adding #{movie.title}"
    bookmark = Bookmark.new(list_id: list_id, movie_id: movie.id)
    bookmark.save!
  end
end

def create_collection(collection_data)
  movie_record = Movie.find_by(tmdb_id: collection_data["id"])
  puts "==============================================="
  puts "Creating new collection: #{collection_data["name"]}"
  # Create Collection List
  backdrop = "https://image.tmdb.org/t/p/original" + collection_data["backdrop_path"] if collection_data["backdrop_path"] != nil
  List.exists?(name: collection_data["name"]) ? "Unable to create list" : List.create!(name: collection_data["name"], backdrop: backdrop)

  tmdb_key = ENV["TMDB_KEY"]
  # Create any missing movies
  create_movie(collection_data, collection_data["name"])
  # collection_data["parts"].each do |movie|
  #   movie_data = api_call(@base_tmdb_endpoint + "#{movie["id"]}?api_key=#{tmdb_key}")
  #   if movie_record.nil?
  #     create_movie(movie_data, collection_data["name"])
  #   else
  #     movie = movie_record
  #     movie.tag_list.add(collection_data["name"])
  #     movie.save!
  #   end
  # end
end

# ===============================================
# LISTS CREATION
# ===============================================

# Create Genre List
genres_data = api_call(genres_tmdb_endpoint)
genres_data["genres"].each do |genre|
  puts "==============================================="
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
# CREATE MOVIES
# ===============================================

# Create Movies from each genre (19 genres in total)
page = 0
genres_data["genres"].each do |genre|
  1.times do
    page += 1
    movies_data = api_call(discover_tmdb_endpoint + "?api_key=#{tmdb_token}&include_adult=false&with_genres=#{genre["id"]}&page=#{page}")
    create_movie(movies_data, genre)
  end
end

# # Get ids from different languages
# page = 0
# @languages.each do |lang|
#   1.times do
#     puts "==============================================="
#     page += 1
#     movies_data = api_call(discover_tmdb_endpoint + "#{tmdb_api_key}&with_original_language=#{lang}&page=#{page}")
#     add_movie_ids(movies_data)
#   end
# end

# # ===============================================
# # COLLECTIONS CREATION
# # ===============================================
# movies_collections = Movie.select(:collection_id).where.not(collection_id: nil).distinct
# movies_collections.each do |collection|
#   collection_data = api_call(collection_tmdb_endpoint + "#{collection.collection_id}#{tmdb_api_key}")
#   create_collection(collection_data)
#   movies_collections.reject(collection)
# end


# # ===============================================
# # BOOKMARKS CREATION
# # ===============================================

@lists = List.all
@lists.each do |list|
  movies = Movie.tagged_with(list.name)
  create_bookmark(list.id, movies)
end
