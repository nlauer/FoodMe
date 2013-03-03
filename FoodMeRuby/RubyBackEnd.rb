require "sinatra"

set :views, settings.root + '/../views'
set :public_folder, File.dirname(__FILE__) + '/../static'

get '/' do
  "Welcome to FoodMe, you should <a href='/register'>register</a>"
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
  "params #{params}"
end

post '/order' do

end
