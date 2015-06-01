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
#   hubot sms <phone number> <text> - Send <text> to <phone number>
#
# Author:
#   Kazuma Ieiri

querystring = require 'querystring'
client = require('twilio')(process.env.HUBOT_TWILIO_ACCOUNT_SID, process.env.HUBOT_TWILIO_AUTH_TOKEN)

module.exports = (robot) ->
  robot.respond /(call|sms) ([^"]+)/i, (msg) ->
    options = msg.match[2].split(' ')
    to_phone_number = options[0]
    send_text = options[1]
    return unless send_text?

    #call
    if msg.match[1] == "call"
      twiml = "<Response><Say voice=\"#{process.env.HUBOT_TWILIO_VOICE_TYPE ? "woman"}\" language=\"#{process.env.HUBOT_TWILIO_LANGUAGE ? "ja-jp"}\">#{send_text}</Say></Response>"
      client.makeCall {
        to: to_phone_number
        from: process.env.HUBOT_TWILIO_FROM_PHONE_NUMBER
        url: "http://twimlets.com/echo?Twiml=#{querystring.escape(twiml)}"
      }, (err, responseData) ->
        if err?
          robot.logger.error err
          msg.send("error: #{err.message}")
        else
          msg.send("Call to #{to_phone_number}")
    #sms
    else
      client.sendMessage {
        to: to_phone_number
        from: process.env.HUBOT_TWILIO_FROM_PHONE_NUMBER
        body: send_text
      }, (err, responseData) ->
        if err?
          robot.logger.error err
          msg.send("error: #{err.message}")
        else
          msg.send("Send to #{to_phone_number}")

