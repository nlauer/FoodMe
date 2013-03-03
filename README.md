FoodMe
======

Launch Hackathon


Ordrin API keys:
public: U-o5Jb1VJ6Odx4Z8qEU3EGt3_xCrO7G2gfZBdsKysEA
secret: b6MDqRkxBDZs6l9ArgOZEdb0ifbYobSUXlzdX4hRi5M

Yelp API Keys:
Consumer Key  hZYNzSXdlHrUwAJP933sJQ
Consumer Secret giNKpzUwVQxI8ijEDjvq1N9IpDw
Token nrjOX80WLa5HLTC644UzJaSTiI3yT2LE
Token Secret  OdwnM8F3JE0A11-VkKOMbx-Y67U




#### tools to use:
- jquery.payment: https://stripe.com/blog/jquery-payment


Things we need to know about the user to register
-------------------------------------------------
#### Combined List:
- email
- password
- first name, last name
- phone #

cc:
- number,
- cvc
- m/y expiry
- billing address
(infer type, phone #, name on card)

####Sources:

place order: https://hackfood.ordr.in/docs/order#cardOrder
- email
- password (sha, api explorer)
- first name, last name
- card nickname (we should just use one)
- phone #

create account (https://hackfood.ordr.in/docs/user#create_account):
- email
- password
- first_name
- last_name

add credit card (https://hackfood.ordr.in/explorer/user/addCreditCard)
- nick (we'll just use the same one everywhere, don't ask user)
- number (15 or 16 digits)
- cvc (3/4 digit code)
- mm/YYYY expiry
- type (we can infer, jeezus)
- billing address
- name on card
- bill state
- bill zip
- bill phone # (probably use same)


#### AMK front-end TODO:
x login saves cookie
x user knows whether he's logged in or not
- show registration link depending on user status
- registration also saves username/password to same cookie
- 'order' page/button
- 'order page/button with location
- 'order page/button with location guessing
- CC validation on front-end
- prettier bootstrap theme
