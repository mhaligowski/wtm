var wtm = wtm || {};

wtm.update = function(ce, perdiodical_executer) {
  var current = (new Date()).getTime();
  var old = Number(ce.readAttribute('data-start'));
  var diff = Math.floor((current - old) / 1000); // seconds only

  var seconds = diff % 60; diff = Math.floor(diff / 60); if (seconds < 10) seconds = "0" + seconds;
  var minutes = diff % 60; diff = Math.floor(diff / 60); if (minutes < 10) minutes = "0" + minutes;
  var hours = diff; if (hours < 10) hours = "0" + hours;

  // update the clock
  ce.update("(" + hours + ":" + minutes + ":" + seconds + ")");
};

wtm.start_clock = function(elem) {
  // stop the earlier clock
  if (wtm.timer[elem.parentElement.id] != null) {
    wtm.timer[elem.parentElement.id].stop();
  }

  // the clock must be running
  if (!elem.parentElement.hasClassName('running')) return;

  // create the time
  wtm.update(elem);
  wtm.timer[elem.parentElement.id] = new PeriodicalExecuter(function(pe) { wtm.update(elem, pe); }, 1);
};

wtm.timer = {}

// at starting the page
Event.observe(window, 'load', function() {
  $$('.clock').each( function(item) {
    wtm.start_clock(item);
  });
});
