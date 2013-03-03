require "sinatra"
require "ordrin"

API_KEY = "U-o5Jb1VJ6Odx4Z8qEU3EGt3_xCrO7G2gfZBdsKysEA"
SECRET_API_KEY = "b6MDqRkxBDZs6l9ArgOZEdb0ifbYobSUXlzdX4hRi5M"

api = Ordrin::APIs.new(SECRET_API_KEY, :test)

set :views, settings.root + '/../views'
set :public_folder, File.dirname(__FILE__) + '/../static'

get '/' do
  erb :index
end

get'/register/?' do
	erb :register
end

get '/login/?' do
  "Hello"
end

post '/login/:name&password' do

end

post '/register/complete/?' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  puts api.user.create(login,params[:first_name],params[:last_name])
  "#{api.user.get(login)}"
end

post '/order' do

end
