## Finite-Countdown

A countdown plugin that reflects the difference to an ending-time regardless of a user's local timezone.

### Install

```
npm-install "finite-countdown"
OR
bower-install "finite-countdown"
```

### Usage

```
var finiteCountdown = require("finite-countdown");

// ending-time as a valid DateString
var end = "2014/11/25 13:00:00";

// additional options
var opts = {
  timezone: "America/New_York", // timezone in context of the ending-time
  selector: ".countdown",       // jquery selector for the countdown's parent container
  format: "dd:hh:mm:ss"         // remaining time display format
};                              // -- hh:mm:ss & dd:hh:mm:ss currently supported

// start and display the countdown
finiteCountdown(end, opts);
```

### Defaults

```
defaults =
  selector: ".countdown"
  timezone: "America/Los_Angeles"
  format: "hh:mm:ss"
```

###Dependencies

- [Moment.js](http://momentjs.com/) - Parse, validate, manipulate, and display dates in javascript.
- [Moment Timezone](http://momentjs.com/timezone/) - Parse and display dates in any timezone.
- [jQuery](http://jquery.com/)
