require "ordrin"

class OrdrInUtils

    @@address = Ordrin::Data::Address.new('1 Main Street', 'College Station', 'TX', '77840', '(555) 555-5555')

    def initialize(login, key)
        @login = login
        @api = key
    end

    public

    def randoOrder(price, address)
        restaurant = randoRestau(address)
        items ||= []
        counter = 0.0
        while counter < price do
            item = randoItem(restaurant["id"], price - counter)
            break if item.nil?
            counter += Float(item["price"])
            items << item
        end
        puts items
        return "test"
    end

    def randoRestau(address)
        restaurants = @api.restaurant.get_delivery_list('ASAP', address)
        return restaurants[rand(restaurants.length)]
    end

    private

    def randoItem(restaurantId, maxprice)
        base = @api.restaurant.get_details(restaurantId)
        menu = getItemsWithMinimumPrice(base["menu"], 5.00, maxprice)
        return menu[rand(menu.length)]
    end

    def getItemsWithMinimumPrice(array, price, maxprice)
        items ||= []
        items = array.select { |x| x.kind_of?(Hash) && !x["price"].nil? && Float(x["price"]) >= price && Float(x["price"]) <= maxprice}
        array.each do |x|
            next if !x.kind_of?(Hash) || x["children"].nil?
            items += getItemsWithMinimumPrice(x["children"], price, maxprice)
        end
        array.each { |x|
            next if !x.kind_of?(Array)
            items += getItemsWithMinimumPrice(x, price, maxprice)
        }
        return items
    end

end
