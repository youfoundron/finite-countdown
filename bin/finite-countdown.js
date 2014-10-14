(function() {
  var countDays, countHours, countMinutes, countSeconds, defaults, finiteCountdown, getLocalDifference, getRemainingTime, has_days, has_days_padded, has_hours, has_hours_padded, has_minutes, has_minutes_padded, has_seconds, has_seconds_padded, moment;

  moment = require('moment');

  require('moment-timezone');

  require('jquery');

  defaults = {
    selector: '.countdown',
    timezone: 'America/Los_Angeles',
    format: 'hh:mm:ss',
    delimiter: ":",
    show_units: false,
    remove_on_end: false
  };

  has_days = /d/i;

  has_days_padded = /dd/i;

  has_hours = /h/i;

  has_hours_padded = /hh/i;

  has_minutes = /m/i;

  has_minutes_padded = /mm/i;

  has_seconds = /s/i;

  has_seconds_padded = /ss/i;

  finiteCountdown = function(end, opts) {
    var $countdown, $days, $days_unit, $delimiter, $hours, $hours_unit, $minutes, $minutes_unit, $seconds, $seconds_unit, counter, days_included, days_padded, delimiter, format, hours_included, hours_padded, minutes_included, minutes_padded, remove_on_end, seconds_included, seconds_padded, selector, show_units, timezone, units;
    if (!opts) {
      opts = defaults;
    }
    selector = opts.selector || ".countdown";
    timezone = opts.timezone || "America/Los_Angeles";
    format = opts.format || "hh:mm:ss";
    delimiter = opts.delimiter || ":";
    show_units = opts.show_units || false;
    remove_on_end = opts.remove_on_end || false;
    days_included = format.match(has_days) ? true : false;
    hours_included = format.match(has_hours) ? true : false;
    minutes_included = format.match(has_minutes) ? true : false;
    seconds_included = format.match(has_seconds) ? true : false;
    days_padded = format.match(has_days_padded) ? true : false;
    hours_padded = format.match(has_hours_padded) ? true : false;
    minutes_padded = format.match(has_minutes_padded) ? true : false;
    seconds_padded = format.match(has_minutes_padded) ? true : false;
    $countdown = $(selector);
    $delimiter = $('<span/>').addClass('delimiter').text(delimiter);
    if (days_included) {
      $days = $('<span/>').addClass('days');
    }
    if (hours_included) {
      $hours = $('<span/>').addClass('hours');
    }
    if (minutes_included) {
      $minutes = $('<span/>').addClass('minutes');
    }
    if (seconds_included) {
      $seconds = $('<span/>').addClass('seconds');
    }
    if (days_included && show_units) {
      $days_unit = $('<span/>').addClass('days-unit').text(' Days ');
    }
    if (hours_included && show_units) {
      $hours_unit = $('<span/>').addClass('hours-unit').text(' Hours ');
    }
    if (minutes_included && show_units) {
      $minutes_unit = $('<span/>').addClass('minutes-unit').text(' Minutes ');
    }
    if (seconds_included && show_units) {
      $seconds_unit = $('<span/>').addClass('seconds-unit').text(' Seconds ');
    }
    if (days_included) {
      $countdown.append($days);
    }
    if (days_included && show_units) {
      $countdown.append($days_unit);
    }
    if (hours_included) {
      $countdown.append($hours);
    }
    if (hours_included && show_units) {
      $countdown.append($hours_unit);
    }
    if (minutes_included) {
      $countdown.append($minutes);
    }
    if (minutes_included && show_units) {
      $countdown.append($minutes_unit);
    }
    if (seconds_included) {
      $countdown.append($seconds);
    }
    if (seconds_included && show_units) {
      $countdown.append($seconds_unit);
    }
    if (show_units === false) {
      units = $countdown.find('span');
      units.splice(units.length - 1, 1);
      $.each(units, function(i, unit) {
        return $delimiter.clone().insertAfter($(unit));
      });
    }
    return counter = setInterval(function() {
      var dd, hh, mm, remaining, ss;
      dd = void 0;
      hh = void 0;
      mm = void 0;
      ss = void 0;
      remaining = getRemainingTime(end, timezone) / 1000;
      if (days_included) {
        dd = countDays(remaining);
        if ((-1 < dd && dd < 10) && days_padded) {
          dd = "0" + dd;
        }
        remaining = remaining % 86400;
      }
      if (hours_included) {
        hh = countHours(remaining);
        if ((-1 < hh && hh < 10) && hours_padded) {
          hh = "0" + hh;
        }
        remaining = remaining % 3600;
      }
      if (minutes_included) {
        mm = countMinutes(remaining);
        if ((-1 < mm && mm < 10) && minutes_padded) {
          mm = "0" + mm;
        }
        remaining = remaining % 60;
      }
      ss = countSeconds(remaining);
      if ((-1 < ss && ss < 10) && seconds_padded) {
        ss = "0" + ss;
      }
      if (days_included) {
        $days.html("" + dd);
      }
      if (hours_included) {
        $hours.html("" + hh);
      }
      if (minutes_included) {
        $minutes.html("" + mm);
      }
      if (seconds_included) {
        $seconds.html("" + ss);
      }
      if (show_units) {
        if (days_included) {
          if (parseInt(dd) === 1) {
            $days_unit.text(' Day ');
          }
          if (parseInt(dd) !== 1 && $days_unit.text() !== ' Days ') {
            $days_unit.text(' Days ');
          }
        }
        if (hours_included) {
          if (parseInt(hh) === 1) {
            $hours_unit.text(' Hour ');
          }
          if (parseInt(hh) !== 1 && $hours_unit.text() !== ' Hours ') {
            $hours_unit.text(' Hours ');
          }
        }
        if (minutes_included) {
          if (parseInt(mm) === 1 && show_units) {
            $minutes_unit.text(' Minute ');
          }
          if (parseInt(mm) !== 1 && $minutes_unit.text() !== ' Minutes ') {
            $minutes_unit.text(' Minutes ');
          }
        }
        if (seconds_included) {
          if (parseInt(ss) === 1 && show_units) {
            $seconds_unit.text(' Second ');
          }
          if (parseInt(ss) !== 1 && $seconds_unit.text() !== ' Seconds ') {
            $seconds_unit.text(' Seconds ');
          }
        }
      }
      if (remaining < 0) {
        if (remove_on_end) {
          $countdown.remove();
        }
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
