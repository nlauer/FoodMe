require "ordrin"

class OrdrInUtils

    @@address = Ordrin::Data::Address.new('1 Main Street', 'College Station', 'TX', '77840', '(555) 555-5555')

    def initialize(login, key)
        @login = login
        @api = key
    end

    def randoRestau()
        restaurants = @api.restaurant.get_delivery_list('ASAP', @@address)
        index = rand(restaurants.length)
        restaurant = restaurants[index]
        item = randoItem(restaurant["id"])
        return restaurant
    end

    def randoItem(restaurantId)
        base = @api.restaurant.get_details(restaurantId)
        menu = base.select { |x| x["price"].nil? }
        # puts menu
        return menu
    end

end
