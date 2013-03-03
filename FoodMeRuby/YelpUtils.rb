require "yelpster"

class YelpUtils


@@CONSUMER_KEY = "hZYNzSXdlHrUwAJP933sJQ"
@@CONSUMER_SECRET = "giNKpzUwVQxI8ijEDjvq1N9IpDw"
@@TOKEN = "nrjOX80WLa5HLTC644UzJaSTiI3yT2LE"
@@TOKEN_SECRET = "OdwnM8F3JE0A11-VkKOMbx-Y67U"


def initialize()
  @yelp_client = Yelp::Client.new
end

public 

def GetYelpRating(restaurant)
  restaurant_term = restaurant["na"].split(/\s+/, 3)[0...2].join(' ')
  na = restaurant["ad"].split(", ")
  restaurant_address = na[0].split(' ').map(&:capitalize).join(' ').tr('-',' ')
  restaurant_city = na[1]
  restaurant_state = na[2]
  request = Yelp::V2::Search::Request::Location.new(:term => restaurant_term,:limit => 1, :address => restaurant_address, :city => restaurant_city,:state => restaurant_state, :consumer_key => @@CONSUMER_KEY, :consumer_secret => @@CONSUMER_SECRET, :token => @@TOKEN, :token_secret => @@TOKEN_SECRET)
  response = @yelp_client.search(request)
  if response["error"] || response["total"] == 0
    return ""
  end
  return response["businesses"][0]["rating"] 
end

end