load 'FoodMeRuby/mailgun.rb'

class EmailUtils
  Mailgun::init("key-7qu7x28lo9zcdun2gw51r2fq5qi37no7")

  def initialize()
  end

  def EmailRegistrationError(email)
    MailgunMessage::send_text("Jesse@justfeedme.mailgun.org",
    "'Foodventurer' <#{email}>",
    "Not Yet available in your location",
    "Dear Foodventurer,
    \nThanks for your interest in JustFeedMe
    \nWe're currently not available in your area but we're expanding rapidly.
    \nJust stay tune.
    \n -Jesse@JustFeedMe",
    "")
  end

  def EmailOrderError(email)
    MailgunMessage::send_text("Jesse@justfeedme.mailgun.org",
    "'Foodventurer' <#{email}>",
    "Order Failed",
    "Dear Foodventurer,
    \nSorry we can not deliver food to your area at this moment.
    \n -Jesse@JustFeedMe",
    "")
  end

end