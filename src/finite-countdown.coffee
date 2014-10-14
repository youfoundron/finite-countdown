moment    = require('moment')
require('moment-timezone')
require('jquery')

defaults =
  selector: '.countdown'
  timezone: 'America/Los_Angeles'
  format: 'hh:mm:ss'
  delimiter: ":"
  show_units: false
  remove_on_end: false

has_days = ///d///i
has_days_padded = ///dd///i
has_hours = ///h///i
has_hours_padded = ///hh///i
has_minutes = ///m///i
has_minutes_padded = ///mm///i
has_seconds = ///s///i
has_seconds_padded = ///ss///i

finiteCountdown = (end, opts) ->
  opts = defaults unless opts

  selector      = opts.selector      || ".countdown"
  timezone      = opts.timezone      || "America/Los_Angeles"
  format        = opts.format        || "hh:mm:ss"
  delimiter     = opts.delimiter     || ":"
  show_units    = opts.show_units    || false
  remove_on_end = opts.remove_on_end || false

  days_included     = if format.match has_days then true else false
  hours_included    = if format.match has_hours then true else false
  minutes_included  = if format.match has_minutes then true else false
  seconds_included  = if format.match has_seconds then true else false

  days_padded       = if format.match has_days_padded then true else false
  hours_padded      = if format.match has_hours_padded then true else false
  minutes_padded    = if format.match has_minutes_padded then true else false
  seconds_padded    = if format.match has_minutes_padded then true else false

  $countdown    = $(selector)
  $delimiter    = $('<span/>').addClass('delimiter').text delimiter

  $days         = $('<span/>').addClass 'days'    if days_included
  $hours        = $('<span/>').addClass 'hours'   if hours_included
  $minutes      = $('<span/>').addClass 'minutes' if minutes_included
  $seconds      = $('<span/>').addClass 'seconds' if seconds_included

  $days_unit    = $('<span/>').addClass('days-unit').text ' Days '        if days_included && show_units
  $hours_unit   = $('<span/>').addClass('hours-unit').text ' Hours '      if hours_included && show_units
  $minutes_unit = $('<span/>').addClass('minutes-unit').text ' Minutes '  if minutes_included && show_units
  $seconds_unit = $('<span/>').addClass('seconds-unit').text ' Seconds '  if seconds_included && show_units

  $countdown.append($days)         if days_included
  $countdown.append($days_unit)    if days_included && show_units
  $countdown.append($hours)        if hours_included
  $countdown.append($hours_unit)   if hours_included && show_units
  $countdown.append($minutes)      if minutes_included
  $countdown.append($minutes_unit) if minutes_included && show_units
  $countdown.append($seconds)      if seconds_included
  $countdown.append($seconds_unit) if seconds_included && show_units

  if show_units is false
    units = $countdown.find 'span'
    units.splice units.length-1, 1
    $.each units, (i, unit) ->
      $delimiter.clone().insertAfter $(unit)

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
    ss = countSeconds remaining
    ss = "0#{ss}" if -1 < ss < 10 && seconds_padded

    $days.html    "#{dd}" if days_included
    $hours.html   "#{hh}" if hours_included
    $minutes.html "#{mm}" if minutes_included
    $seconds.html "#{ss}" if seconds_included

    if show_units
      if days_included
        $days_unit.text ' Day ' if parseInt(dd) == 1
        $days_unit.text ' Days ' if parseInt(dd) != 1 && $days_unit.text() != ' Days '
      if hours_included
        $hours_unit.text ' Hour ' if parseInt(hh) == 1
        $hours_unit.text ' Hours ' if parseInt(hh) != 1 && $hours_unit.text() != ' Hours '
      if minutes_included
        $minutes_unit.text ' Minute ' if parseInt(mm) == 1 && show_units
        $minutes_unit.text ' Minutes ' if parseInt(mm) != 1 && $minutes_unit.text() != ' Minutes '
      if seconds_included
        $seconds_unit.text ' Second ' if parseInt(ss) == 1 && show_units
        $seconds_unit.text ' Seconds ' if parseInt(ss) != 1 && $seconds_unit.text() != ' Seconds '

    if remaining < 0
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
