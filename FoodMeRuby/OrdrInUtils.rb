require "ordrin"

class OrdrInUtils

    @@address = Ordrin::Data::Address.new('1 Main Street', 'College Station', 'TX', '77840', '(555) 555-5555')

    def initialize(login, key)
        @login = login
        @api = key
    end

    public

    def randoOrder(price, restaurant)
        items ||= []
        counter = 0.0
        while counter < price do
            item = randoItem(restaurant["id"], price - counter)
            break if item.nil?
            puts item
            subitems = getSubItems(item)
            if !subitems.nil?
                puts subitems
            end
            counter += Float(item["price"])
            items << item
        end
        return items
    end

    def randoRestau(address)
        restaurants = @api.restaurant.get_delivery_list('ASAP', address)
        return restaurants[rand(restaurants.length)]
    end

    def assembleOrderId(order)
        result = ""
        order.each do |x|
            if result.length > 0
                result += "+"
            end
            result += x["id"]
        end
        puts result
        return result
    end

    private

    def getSubItems(item)
        item = item["children"]
        return if item.nil?
        subcategories ||= []
        item.each do |x| #explore sub categories
            subcategories << x
        end
        return subitems
    end

    def randoItem(restaurantId, maxprice)
        base = @api.restaurant.get_details(restaurantId)
        menu = getAllMainItems(base["menu"])
        menu = getItemsWithMinimumPrice(menu, 5.00, maxprice)
        return menu[rand(menu.length)]
    end

    def getAllMainItems(menu)
        categories ||= []
        menu.each do |x|
            categories << x
        end
        items ||= []
        categories.each do |x|
            next if x["children"].nil?
            items += x["children"]
        end
        return items
    end

    def getItemsWithMinimumPrice(array, price, maxprice)
        items = array.select { |x| x.kind_of?(Hash) && !x["price"].nil? && Float(x["price"]) >= price && Float(x["price"]) <= maxprice}
        return items
    end

end
