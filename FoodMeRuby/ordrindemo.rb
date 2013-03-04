#! /usr/bin/env ruby
require 'date'
require 'securerandom'
require 'pp'

begin
  require 'ordrin'
rescue LoadError
  require 'rubygems'
  begin
    require 'ordrin'
  rescue LoadError
    require_relative '../lib/ordrin'
  end
end

module OrdrinDemo
  #
  # Global Variables
  #
  print "Please input your API key: "
  STDOUT.flush
  api_key = gets.chomp

  @@api = Ordrin::APIs.new(api_key, :test)

  # Create an Address object
  @@address = Ordrin::Data::Address.new('1 Main Street', 'College Station', 'TX', '77840', '(555) 555-5555')
  @@address_nick = 'addr1'

  # Create a CreditCard object
  @@first_name = 'Test'
  @@last_name = 'User'
  @@credit_card = Ordrin::Data::CreditCard.new("#{@@first_name} #{@@last_name}", '01', (Date.today.year+2).to_s, @@address, '4111111111111111', '123')
  @@credit_card_nick = 'cc1'

  unique_id = SecureRandom.uuid.to_s.gsub(/-/, '')
  @@email = "demo+#{unique_id}ruby@ordr.in"
  @@password = 'password'
  @@login = Ordrin::Data::UserLogin.new(@@email, @@password)
  @@alt_first_name = 'Example'
  @@alt_email = "demo+#{unique_id}rubyalt@ordr.in"
  @@alt_login = Ordrin::Data::UserLogin.new(@@alt_email, @@password)
  @@new_password = 'password1'

  #
  # Restaurant demo functions
  #

  def OrdrinDemo.delivery_list_immediate_demo()
    puts "Get a list of restaurants that will deliver if you order now"
    print "Press enter to execute and see the response"
    gets
    delivery_list_immediate = @@api.restaurant.get_delivery_list('ASAP', @@address)
    PP.pp(delivery_list_immediate)
    return delivery_list_immediate
  end

  def OrdrinDemo.delivery_list_future_demo()
    puts "Get a list of restaurants that will deliver if you order for 12 hours from now"
    print "Press enter to execute and see the response"
    gets
    future_datetime = DateTime.now + 0.5 #A timestamp twelve hours in the future
    delivery_list_later = @@api.restaurant.get_delivery_list(future_datetime, @@address)
    PP.pp(delivery_list_later)
  end

  def OrdrinDemo.delivery_check_demo(restaurant_id)
    puts "Get whether a particular restaurant will deliver if you order now"
    print "Press enter to execute and see the response"
    gets
    delivery_check = @@api.restaurant.get_delivery_check(restaurant_id, 'ASAP', @@address)
    PP.pp(delivery_check)
  end

  def OrdrinDemo.fee_demo(restaurant_id)
    puts "Get fee and other info for ordering a given amount with a given tip"
    print "Press enter to execute and see the response"
    gets
    subtotal = "$30.00"
    tip = "$5.00"
    fee_info = @@api.restaurant.get_fee(restaurant_id, subtotal, tip, 'ASAP', @@address)
    PP.pp(fee_info)
  end

  def OrdrinDemo.detail_demo(restaurant_id)
    puts "Get detailed information about a single restaurant"
    print "Press enter to execute and see the response"
    gets
    restaurant_detail = @@api.restaurant.get_details(restaurant_id)
    PP.pp(restaurant_detail)
    return restaurant_detail
  end

  def OrdrinDemo.find_deliverable_time(restaurant_id)
    puts "Find a time when this restaurant will deliver"
    print "Press enter to execute and see the response"
    gets
    delivery_check = @@api.restaurant.get_delivery_check(restaurant_id, 'ASAP', @@address)
    delivery = delivery_check['delivery']
    if delivery
      return 'ASAP'
    end
    dt = DateTime.now + 1/24.0
    while not delivery
      delivery_check = @@api.restaurant.get_delivery_check(restaurant_id, dt, @@address)
      delivery = delivery_check['delivery']
      dt += 1/24.0
    end
    return dt
  end    
  #
  # User demo functions
  #

  def OrdrinDemo.get_user_demo()
    puts "Get information about a user"
    print "Press enter to execute and see the response"
    gets
    user_info = @@api.user.get(@@login)
    PP.pp(user_info)
  end

  def OrdrinDemo.create_user_demo()
    puts "Create a user"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.create(@@login, @@first_name, @@last_name)
    PP.pp(response)
  end

  def OrdrinDemo.update_user_demo()
    puts "Update a user"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.update(@@login, @@alt_first_name, @@last_name)
    PP.pp(response)
  end

  def OrdrinDemo.get_all_addresses_demo()
    puts "Get a list of all saved addresses"
    print "Press enter to execute and see the response"
    gets
    address_list = @@api.user.get_all_addresses(@@login)
    PP.pp(address_list)
  end

  def OrdrinDemo.get_address_demo()
    puts "Get an address by nickname"
    print "Press enter to execute and see the response"
    gets
    addr = @@api.user.get_address(@@login, @@address_nick)
    PP.pp(addr)
  end

  def OrdrinDemo.set_address_demo()
    puts "Save an address with a nickname"
    response = @@api.user.set_address(@@login, @@address_nick, @@address)
    PP.pp(response)
  end

  def OrdrinDemo.remove_address_demo()
    puts "Remove a saved address by nickname"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.remove_address(@@login, @@address_nick)
    PP.pp(response)
  end

  def OrdrinDemo.get_all_credit_cards_demo()
    puts "Get a list of all saved credit cards"
    credit_card_list = @@api.user.get_all_credit_cards(@@login)
    PP.pp(credit_card_list)
  end

  def OrdrinDemo.get_credit_card_demo()
    puts "Get a saved credit card by nickname"
    print "Press enter to execute and see the response"
    gets
    credit_card = @@api.user.get_credit_card(@@login, @@credit_card_nick)
    PP.pp(credit_card)
  end

  def OrdrinDemo.set_credit_card_demo()
    puts "Save a credit card with a nickname"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.set_credit_card(@@login, @@credit_card_nick, @@credit_card)
    PP.pp(response)
  end

  def OrdrinDemo.remove_credit_card_demo()
    puts "Remove a saved credit card by nickname"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.remove_credit_card(@@login, @@credit_card_nick)
    PP.pp(response)
  end

  def OrdrinDemo.get_order_history_demo(login)
    puts "Get a list of all orders made by this user"
    print "Press enter to execute and see the response"
    gets
    order_list = @@api.user.get_order_history(@@login)
    PP.pp(order_list)
  end

  def OrdrinDemo.get_order_detail_demo(oid)
    puts "Get the details of a particular order made by this user"
    print "Press enter to execute and see the response"
    gets
    order_detail = @@api.user.get_order_detail(@@login, oid)
    PP.pp(order_detail)
  end

  def OrdrinDemo.set_password_demo()
    puts "Set a new password for a user"
    print "Press enter to execute and see the response"
    gets
    response = @@api.user.set_password(@@login, @@new_password)
    PP.pp(response)
  end
  
  #
  # Order demo functions
  #

  def OrdrinDemo.anonymous_order_demo(restaurant_id, tray, date_time)
    puts "Order food as someone without a user account"
    print "Press enter to execute and see the response"
    gets
    tip = Random.rand(500)/100.0
    response = @@api.order.order(restaurant_id, tray, tip, date_time, @@first_name, @@last_name, @@address, @@credit_card, @@email)
    PP.pp(response)
  end

  def OrdrinDemo.create_user_and_order_demo(restaurant_id, tray, date_time)
    puts "Order food and create an account"
    print "Press enter to execute and see the response"
    gets
    tip = Random.rand(500)/100.0
    response = @@api.order.order_create_user(restaurant_id, tray, tip, date_time, @@first_name, @@last_name, @@address, @@credit_card, @@alt_email, @@password)
    PP.pp(response)
  end

  def OrdrinDemo.order_with_nicks_demo(restaurant_id, tray, date_time)
    puts "Order food as a logged in user using previously stored address and credit card"
    print "Press enter to execute and see the response"
    gets
    tip = Random.rand(500)/100.0
    response = @@api.order.order(restaurant_id, tray, tip, date_time, @@first_name, @@last_name, @@address_nick, @@credit_card_nick, nil, @@login)
    PP.pp(response)
    return response
  end

  def OrdrinDemo.find_item_to_order(item_list)
    for item in item_list
      if item['is_orderable']=='1'
        if item['price'].to_f>=5.00
          return item['id']
        end
      else
        if item.has_key?('children')
          item_id = find_item_to_order(item['children'])
          unless item_id.nil?
            return item_id
          end
        end
      end
    end
    nil
  end
  

  #
  # Main
  #
  def OrdrinDemo.run_demo()
    puts "Run through the entire demo sequence"
    # Restaurant functions
    delivery_list = delivery_list_immediate_demo()
    delivery_list_future_demo()
    restaurant_id = delivery_list[0]['id']
    delivery_check_demo(restaurant_id)
    fee_demo(restaurant_id)
    detail = detail_demo(restaurant_id)

    # User functions
    create_user_demo()
    get_user_demo()
    update_user_demo()
    get_user_demo()
    set_address_demo()
    get_address_demo()
    set_credit_card_demo()
    get_credit_card_demo()

    # Order functions
    order_date_time = find_deliverable_time(restaurant_id)
    puts "Ordering food at #{order_date_time}"
    item_id = find_item_to_order(detail['menu'])
    item = Ordrin::Data::TrayItem.new(item_id, 10)
    tray = Ordrin::Data::Tray.new(item)
    anonymous_order_demo(restaurant_id, tray, order_date_time)
    order = order_with_nicks_demo(restaurant_id, tray, order_date_time)
    unless order.nil?
      get_order_detail_demo(order['refnum'])
    end

    create_user_and_order_demo(restaurant_id, tray, order_date_time)
    get_order_history_demo(@@alt_login)

    # Clean up/removing stuff
    remove_address_demo()
    get_all_addresses_demo()
    remove_credit_card_demo()
    get_all_credit_cards_demo()
    set_password_demo()
    #After changing the password I must change the login object to continue to access user info
  end

  run_demo()
end
