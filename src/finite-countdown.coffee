moment    = require('moment')
require('moment-timezone')
require('jquery')

has_days = ///d///i
has_days_padded = ///dd///i
has_hours = ///h///i
has_hours_padded = ///dd///i
has_minutes = ///m///i
has_minutes_padded = ///mm///i
has_seconds = ///m///i
has_seconds_padded = ///mm///i

finiteCountdown = (end, opts) ->
  defaults =
    selector: '.countdown'
    timezone: 'America/Los_Angeles'
    format: 'hh:mm:ss'
    delimiter: ":"
    show_units: false
    remove_on_end: false

  opts = defaults unless opts

  selector      = opts.selector      || ".countdown"
  timezone      = opts.timezone      || "America/Los_Angeles"
  format        = opts.format        || "hh:mm:ss"
  delimiter     = opts.delimiter     || ":"
  show_units    = opts.show_units    || false
  remove_on_end = opts.remove_on_end || false

  days_included     = format.match has_days
  hours_included    = format.match has_hours
  minutes_included  = format.match has_minutes
  seconds_included  = format.match has_seconds

  days_padded       = format.match has_days_padded
  hours_padded      = format.match has_hours_padded
  minutes_padded    = format.match has_minutes_padded
  seconds_padded    = format.match has_minutes_padded

  $countdown    = $(selector)
  $delimiter    = $('<span/>').addClass('delimiter').text delimiter

  $days         = $('<span/>').addClass 'days'    if days_included
  $hours        = $('<span/>').addClass 'hours'   if hours_included
  $minutes      = $('<span/>').addClass 'minutes' if minutes_included
  $seconds      = $('<span/>').addClass 'seconds' if seconds_included

  $days_unit    = $('<span/>').addClass('days-unit').text 'Days'        if days_included && show_units
  $hours_unit   = $('<span/>').addClass('hours-unit').text 'Hours'      if hours_included && show_units
  $minutes_unit = $('<span/>').addClass('minutes-unit').text 'Minutes'  if minutes_included && show_units
  $seconds_unit = $('<span/>').addClass('seconds-unit').text 'Seconds'  if seconds_included && show_units

  $countdown.append($days)         if days_included
  $countdown.append($days_unit)    if days_included && show_units
  $countdown.append($hours)        if hours_included
  $countdown.append($hours_unit)   if hours_included && show_units
  $countdown.append($minutes)      if minutes_included
  $countdown.append($minutes_unit) if minutes_included && show_units
  $countdown.append($seconds)      if seconds_included
  $countdown.append($seconds_unit) if seconds_included && show_units

  unless show_units
    units = $countdown.find 'span'
    units.pop()
    $.each units, (unit) ->
      $(unit).insertAfter $delimiter

  counter = setInterval () ->
    dd = undefined
    hh = undefined
    mm = undefined
    ss = undefined
    # remaining seconds
    remaining = getRemainingTime(end, timezone) / 1000
    # days
    if days_included
      dd = countDays remaining
      dd = "0#{dd}" if -1 < dd < 10 && days_padded
      remaining = remaining % 86400
    # hours
    if hours_included
      hh = countHours remaining
      hh = "0#{hh}" if -1 < hh < 10 && hours_padded
      remaining = remaining % 3600
    # minutes
    if minutes_included
      mm = countMinutes remaining
      mm = "0#{mm}" if -1 < mm < 10 && minutes_padded
      remaining = remaining % 60
    # seconds
    if seconds_included
      ss = countSeconds remaining
      ss = "0#{ss}" if -1 < ss < 10 && seconds_padded

    $days.html    "#{dd}" if days_included
    $hours.html   "#{hh}" if hours_included
    $minutes.html "#{mm}" if minutes_included
    $seconds.html "#{ss}" if seconds_included

    if ss < 0
      $countdown.remove() if remove_on_end
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
