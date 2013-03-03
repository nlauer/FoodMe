FoodMe
======

Launch Hackathon


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

