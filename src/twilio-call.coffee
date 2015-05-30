# Description
#   A Hubot script that calls the twilio API
#
# Dependencies:
#   "querystring": "0.2.0",
#   "twilio": "2.2.1"
#
# Configuration:
#   HUBOT_TWILIO_FROM_PHONE_NUMBER (from phone number)
#   HUBOT_TWILIO_ACCOUNT_SID (twilio API account SID)
#   HUBOT_TWILIO_AUTH_TOKEN (twilio API auth token)
#   HUBOT_TWILIO_VOICE_TYPE (twilio API voice type)
#   HUBOT_TWILIO_LANGUAGE (twilio API language)
#
# Commands:
#   hubot call <phone number> <text> - Call to <phone number> say <text>
#
# Author:
#   Kazuma Ieiri

querystring = require 'querystring'
twilio = require 'twilio'

module.exports = (robot) ->
  robot.respond /call ([^"]+)/i, (msg) ->
    options = msg.match[1].split(' ')
    to_phone_number = options[0]
    say_text = options[1]
    return unless say_text?

    client = twilio(process.env.HUBOT_TWILIO_ACCOUNT_SID, process.env.HUBOT_TWILIO_AUTH_TOKEN)
    twiml = "<Response><Say voice=\"#{process.env.HUBOT_TWILIO_VOICE_TYPE ? "woman"}\" language=\"#{process.env.HUBOT_TWILIO_LANGUAGE ? "ja-jp"}\">#{say_text}</Say></Response>"

    client.makeCall {
      to: to_phone_number
      from: process.env.HUBOT_TWILIO_FROM_PHONE_NUMBER
      url: "http://twimlets.com/echo?Twiml=#{querystring.escape(twiml)}"
    }, (err, responseData) ->
      if err?
        robot.logger.error err
        msg.send("twilio-call: #{responseData.from}")
      else
        msg.send("Calling to #{to_phone_number}")

