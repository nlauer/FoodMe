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


#### Things to do before demo
iOS app:
- set up testflight
- mechanism to 'here's how you get an invite'
- finalize app name
- screenshots or check how iOS demos are done at angelhack

Back-end:
- send email if registration in bad area or order in bad area or any sort of issue (not available yet in your area)
- ordering actually works
- buy domain

Front-end:
- prettier landing page (copy, css)
- prettier bootstrap theme
- pre-filled registration page
- thank you for registering page
maybe:
- order page
- validation at various stages
- 'not yet in your area' message

Demo:
- pick a domain
- hook up domain to heroku
- buy 'easy' button
- make sure all pages are polished and we have a script
- order food to arrive
- get 'easy' button

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


