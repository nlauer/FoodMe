require "sinatra"
require "ordrin"
load "OrdrInUtils.rb"

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
  address = Ordrin::Data::Address.new(params[:'street-address'],params[:city],params[:state],params[:zip],params[:phone_number],params[:'street-address-2'])
  credit_card = Ordrin::Data::CreditCard.new( "#{params[:first_name]} #{params[:last_name]}", params[:'card-expiry-month'], params[:'card-expiry-year'], address,params[:'card-number'],params[:cvc])
  api.user.create(login,params[:first_name],params[:last_name])
  api.user.set_address(login,"home",address)
  api.user.set_credit_card(login,"home",credit_card)
  utils = OrdrInUtils.new(login, api)
  puts utils.randoRestau()
  "#{api.user.get(login)}"
end

post '/order' do

end
