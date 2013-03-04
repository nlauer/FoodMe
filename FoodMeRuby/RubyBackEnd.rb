require "sinatra"
require "ordrin"
require "date"
load "FoodMeRuby/OrdrInUtils.rb"
load "FoodMeRuby/YelpUtils.rb"
load "FoodMeRuby/EmailUtils.rb"
require "json"


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
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  home_address = Ordrin::Data::Address.new(params[:'home-address'],params[:home_city],params[:home_state],params[:home_zip],params[:phone_number],params[:'home-address-2'])
  bill_address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'home-address-2'])
  credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], bill_address,params[:'card-number'],params[:cvc])
  if   checkaddress(home_address)
    api.user.create(login,params[:first_name],params[:last_name])
    api.user.set_address(login,"home",home_address)
    api.user.set_credit_card(login,"home",credit_card)
    "#{api.user.get(login)}"
  else 
    "Registration failed"
  end
end

get '/shipping/?' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_address(login, params[:addr_name]).to_json
end

get '/all_shipping' do
  content_type :json
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  puts " all shipping #{params}"
  api.user.get_all_addresses(login).to_json
end

post '/shipping' do
  puts " posting #{params}"
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  new_address = Ordrin::Data::Address.new(params[:address],params[:city],params[:state],params[:zip],params[:phone_number],params[:'address-2'])
  api.user.set_address(login,params[:address],new_address)
  puts "You have added a new address"
end

get '/credit_card/?' do
  content_type :json
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_credit_card(login,params[:card_name]).to_json
end

get '/all_credit_card' do
  content_type :json
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get_all_credit_cards(login).to_json
end

post '/credit_card' do
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  new_billing_address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'home-address-2'])
  new_credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], new_billing_address,params[:'card-number'],params[:cvc])
  api.user.set_credit_card(login,params[:card_name],new_credit_card)
end


get '/get_account' do
  content_type :json
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  api.user.get(login).to_json
end

get '/order/?' do
  erb :order
end

post '/order' do
  puts "#{params}"
  counter = 0
  login = Ordrin::Data::UserLogin.new(params[:email],params[:password])
  address = api.user.get_address(login, params[:addr_nick])
  newAddress = Ordrin::Data::Address.new(address["addr"],address["city"],address["state"],address["zip"],address["phone"])
  puts newAddress
  utils = OrdrInUtils.new(login, api)
  yelprating = YelpUtils.new()
  retry_count = 0
  begin
      rating = 0
      order = nil
      until (rating =="" || Float(rating) >= 3) && (!order.nil? && !order.empty?)    do
        restaurant = utils.randoRestau(newAddress)
        rating = yelprating.GetYelpRating(restaurant)
        order = utils.randoOrder(Float(params[:price]), restaurant)
      end
      orderTray = utils.assembleOrderId(Float(params[:price]), order)
      puts orderTray
      tip = Float(params[:price])*0.15
      api.order.order(restaurant["id"], orderTray, tip, DateTime.now + 10/24.0, 'PLACE', 'HOLDER', params[:addr_nick], "home", nil, login)
  rescue Ordrin::Errors::ApiError => e
    retry_count += 1
    if retry_count > 3
      emailsender = EmailUtils.new()
      emailsender.EmailOrderError(params[:email])
      raise
    else
      retry
    end
  end
  puts orderTray
end

def checkaddress(homeaddress)
  api = Ordrin::APIs.new(SECRET_API_KEY, :test)
  emailsender = EmailUtils.new()
  restaurant = api.restaurant.get_delivery_list("ASAP", homeaddress)
  if !restaurant.empty? 
    return true
  else 
    emailsender.EmailRegistrationError("jessehysum@gmail.com")
    return false
  end
end
