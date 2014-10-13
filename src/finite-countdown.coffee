moment    = require('moment')
require('moment-timezone')
require('jquery')

###
Usage:

end = "2014/11/25 13:00:00"
opts =
  timezone: "America/New_York"
  selector: '.countdown'
  format: "hh:mm:ss"

finiteCountdown(end, opts)

###

day_pattern =
  ///
  dd    # 'd'x2
  .     # single delimiting character -- ':', '/', '.', etc
  hh    # 'h'x2
  .     #
  mm    # 'm'x2
  .     #
  ss    # 's'x2
  ///i  # ignore case

hour_pattern = ///hh.mm.ss///i

finiteCountdown = (end, opts) ->
  defaults =
    selector: '.countdown'
    timezone: 'America/Los_Angeles'
    format: 'hh:mm:ss'

  opts = defaults unless opts

  selector     = opts.selector || '.countdown'
  timezone     = opts.timezone || "America/Los_Angeles"
  format       = opts.format   || "hh:mm:ss"
  $countdown   = $(selector)
  $days        = $('<span/>').addClass 'days'
  $hours       = $('<span/>').addClass 'hours'
  $minutes     = $('<span/>').addClass 'minutes'
  $seconds     = $('<span/>').addClass 'seconds'

  days_included = format.match day_pattern

  $countdown.append($days).append($hours).append($minutes).append $seconds

  counter = setInterval () ->
    # remaining seconds
    remaining = getRemainingTime(end, timezone) / 1000
    # days
    dd = undefined
    if days_included
      dd = countDays remaining
      dd = "0#{dd}" if -1 < dd < 10
      remaining = remaining % 86400
    # hours
    hh = countHours remaining
    hh = "0#{hh}" if -1 < hh < 10
    remaining = remaining % 3600
    # minutes
    mm = countMinutes remaining
    mm = "0#{mm}" if -1 < mm < 10
    remaining = remaining % 60
    # seconds
    ss = countSeconds remaining
    ss = "0#{ss}" if -1 < ss < 10

    $days.html    "#{dd}:" if days_included
    $hours.html   "#{hh}:"
    $minutes.html "#{mm}:"
    $seconds.html "#{ss}"

    if ss < 0
      $countdown.remove()
      clearInterval counter

  , 1000

countDays = (remaining_seconds) ->
  days = Math.floor remaining_seconds/86400
countHours = (remaining_seconds) ->
  hours = Math.floor remaining_seconds/3600
countMinutes = (remaining_seconds) ->
  minutes = Math.floor remaining_seconds/60
countSeconds = (remaining_seconds) ->
  seconds = Math.floor remaining_seconds

getLocalDifference = (timezone) -> # milliseconds
  now_local  = new Date()
  now_tz     = new Date(moment.tz(now_local, timezone).format("YYYY/MM/DD, HH:mm:ss"))
  difference = now_local - now_tz
  return difference

getRemainingTime = (end, timezone) ->
  now_local = new Date()
  end_local = new Date( (new Date(end)).getTime() + getLocalDifference(timezone) )
  local_remaining = end_local - now_local
  return local_remaining

module.exports = finiteCountdown
