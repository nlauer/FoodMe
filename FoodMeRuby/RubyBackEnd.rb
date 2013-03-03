require "sinatra"
require "ordrin"
load "OrdrInUtils.rb"
load "YelpUtils.rb"

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

post '/register/complete/?' do
  rating = 0
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  home_address = Ordrin::Data::Address.new(params[:'home-address'],params[:home_city],params[:home_state],params[:home_zip],params[:phone_number],params[:'home-address-2'])
  bill_address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'home-address-2'])
  credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], bill_address,params[:'card-number'],params[:cvc])
  api.user.create(login,params[:first_name],params[:last_name])
  api.user.set_address(login,"home",home_address)
  api.user.set_credit_card(login,"home",credit_card)
  utils = OrdrInUtils.new(login, api)
  yelprating = YelpUtils.new()
  until rating =="" || Float(rating) >= 3   do 
    restaurant = utils.randoRestau(home_address)
    rating = yelprating.GetYelpRating(restaurant)
    puts restaurant
    puts rating
  end
  #"#{api.user.get(login)}"
  erb :register_complete
end

post '/order' do

end
