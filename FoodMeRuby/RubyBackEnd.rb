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
  order = nil
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  home_address = Ordrin::Data::Address.new(params[:'home-address'],params[:home_city],params[:home_state],params[:home_zip],params[:phone_number],params[:'home-address-2'])
  bill_address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'home-address-2'])
  credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], bill_address,params[:'card-number'],params[:cvc])
  api.user.create(login,params[:first_name],params[:last_name])
  api.user.set_address(login,"home",home_address)
  api.user.set_credit_card(login,"home",credit_card)
  utils = OrdrInUtils.new(login, api)
  yelprating = YelpUtils.new()
  until (rating =="" || Float(rating) >= 3) && (!order.nil? && !order.empty?)    do
    restaurant = utils.randoRestau(home_address)
    rating = yelprating.GetYelpRating(restaurant)
    order = utils.randoOrder(20.00, restaurant)
  end
  utils.assembleOrderId(order)
  "#{api.user.get(login)}"
  #erb :register_complete
end

get '/shipping/?' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_address(login, params[:addr_name])
end

get '/all_shipping' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.addresses(login)
end

post '/shipping' do
  puts "#{params}"
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  new_address = Ordrin::Data::Address.new(params[:address],params[:city],params[:state],params[:zip],params[:phone_number],params[:'address-2'])
  api.user.set_address(login,params[:address],new_address)
  "You have added a new address"
end

get '/credit_card/?' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_credit_card(login,params[:card_name])
end

get '/all_credit_card' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_all_credit_cards(login)
end

post '/credit_card' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  new_billing_address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'home-address-2'])
  new_credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], new_billing_address,params[:'card-number'],params[:cvc])
  api.user.set_credit_card(login,params[:card_name],new_credit_card)
end

post '/order' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
end
