require "sinatra"

get'/Registration' do
	"Hello World!"
end

get '/Login' do
  "You're logging in #{params[:name]} and #{params[:something]} "
end

post '/Login/:name&password' do

end

post '/Registration' do

end

post '/Order' do

end