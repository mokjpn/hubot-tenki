# Description:
#   Show local weather information from livedoor web service
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   hubot tenki me     - Show the today's weather  in Japanese
#   hubot yohou me     - Show weather forecasts in Japanese

url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=" + process.env.HUBOT_WEATHER_CITYCODE

module.exports = (robot) ->
  robot.respond /(tenki|yohou) me/i, (msg) ->
#x=() ->
    XMLHttpRequest = require('w3c-xmlhttprequest').XMLHttpRequest
    req = new XMLHttpRequest
    req.open("GET", url)
    req.responseType = 'json'
    req.addEventListener('load', (event) ->
      #console.log(req.responseText)
      w = JSON.parse(req.responseText)
      time = new Date(w.description.publicTime)
      mon=time.getMonth()+1
      day=time.getDate()
      if msg.match[1] == "tenki"
        msg.send("#{mon}月#{day}日発表の#{w.location.city}の天気は、#{w.description.text}")
      else
        for i in [0..w.forecasts.length-1]
          fcw = w.forecasts[i]
          #console.log(fcw)
          fcs = "#{fcw.dateLabel}の#{w.location.city}の予報は、#{fcw.telop}. "
          fcs += "最高気温は#{fcw.temperature.max.celsius}℃ " if fcw.temperature.max != null
          fcs += "最低気温は#{fcw.temperature.min.celsius}℃ " if fcw.temperature.min != null
          msg.send(fcs)
    ,false)
    req.send(null)

#x()
