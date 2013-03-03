require "sinatra"
require "ordrin"

set :views, settings.root + '/../views'
set :public_folder, File.dirname(__FILE__) + '/../static'

get'/register' do
	erb :register
end

get '/login' do
  "Hello"
end

post '/login/:name&password' do

end

post '/register/complete/' do
  "params #{params}"
end

post '/order' do

end
