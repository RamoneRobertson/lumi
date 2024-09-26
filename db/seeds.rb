require 'json'
puts "========== Clearing the database =========="
List.destroy_all
User.destroy_all
Movie.destroy_all
motn_token = ENV["MOTN_KEY"]
tmdb_token = ENV["TMDB_KEY"]

genres_tmdb_endpoint = "https://api.themoviedb.org/3/genre/movie/list?api_key=#{tmdb_token}"
upcoming_tmdb_endpoint = "https://api.themoviedb.org/3/movie/now_playing"

def api_call(endpoint)
  api_data = URI.open(endpoint).read
  parsed_json_data = JSON.parse(api_data)
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
  puts "========================"
end

# Create Other Lists
puts "=========== OTHER LISTS ============="
%w(now_playing popular top_rated upcoming).each do |category|
  puts "========================"
  puts "Creating new list: #{category}"
  List.create!(name: category)
  puts "========================"
end

# ===============================================
# MOVIES CREATION
# ===============================================
