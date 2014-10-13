(function() {
  var countDays, countHours, countMinutes, countSeconds, day_pattern, finiteCountdown, getLocalDifference, getRemainingTime, hour_pattern, moment;

  moment = require('moment');

  require('moment-timezone');

  require('jquery');


  /*
  Usage:
  
  end = "2014/11/25 13:00:00"
  opts =
    timezone: "America/New_York"
    selector: '.countdown'
    format: "hh:mm:ss"
  
  finiteCountdown(end, opts)
   */

  day_pattern = /dd.hh.mm.ss/i;

  hour_pattern = /hh.mm.ss/i;

  finiteCountdown = function(end, opts) {
    var $countdown, $days, $hours, $minutes, $seconds, counter, days_included, defaults, format, selector, timezone;
    defaults = {
      selector: '.countdown',
      timezone: 'America/Los_Angeles',
      format: 'hh:mm:ss'
    };
    if (!opts) {
      opts = defaults;
    }
    selector = opts.selector || '.countdown';
    timezone = opts.timezone || "America/Los_Angeles";
    format = opts.format || "hh:mm:ss";
    $countdown = $(selector);
    $days = $('<span/>').addClass('days');
    $hours = $('<span/>').addClass('hours');
    $minutes = $('<span/>').addClass('minutes');
    $seconds = $('<span/>').addClass('seconds');
    days_included = format.match(day_pattern);
    $countdown.append($days).append($hours).append($minutes).append($seconds);
    return counter = setInterval(function() {
      var dd, hh, mm, remaining, ss;
      remaining = getRemainingTime(end, timezone) / 1000;
      dd = void 0;
      if (days_included) {
        dd = countDays(remaining);
        if ((-1 < dd && dd < 10)) {
          dd = "0" + dd;
        }
        remaining = remaining % 86400;
      }
      hh = countHours(remaining);
      if ((-1 < hh && hh < 10)) {
        hh = "0" + hh;
      }
      remaining = remaining % 3600;
      mm = countMinutes(remaining);
      if ((-1 < mm && mm < 10)) {
        mm = "0" + mm;
      }
      remaining = remaining % 60;
      ss = countSeconds(remaining);
      if ((-1 < ss && ss < 10)) {
        ss = "0" + ss;
      }
      if (days_included) {
        $days.html("" + dd + ":");
      }
      $hours.html("" + hh + ":");
      $minutes.html("" + mm + ":");
      $seconds.html("" + ss);
      if (ss < 0) {
        $countdown.remove();
        return clearInterval(counter);
      }
    }, 1000);
  };

  countDays = function(remaining_seconds) {
    var days;
    return days = Math.floor(remaining_seconds / 86400);
  };

  countHours = function(remaining_seconds) {
    var hours;
    return hours = Math.floor(remaining_seconds / 3600);
  };

  countMinutes = function(remaining_seconds) {
    var minutes;
    return minutes = Math.floor(remaining_seconds / 60);
  };

  countSeconds = function(remaining_seconds) {
    var seconds;
    return seconds = Math.floor(remaining_seconds);
  };

  getLocalDifference = function(timezone) {
    var difference, now_local, now_tz;
    now_local = new Date();
    now_tz = new Date(moment.tz(now_local, timezone).format("YYYY/MM/DD, HH:mm:ss"));
    difference = now_local - now_tz;
    return difference;
  };

  getRemainingTime = function(end, timezone) {
    var end_local, local_remaining, now_local;
    now_local = new Date();
    end_local = new Date((new Date(end)).getTime() + getLocalDifference(timezone));
    local_remaining = end_local - now_local;
    return local_remaining;
  };

  module.exports = finiteCountdown;

}).call(this);
