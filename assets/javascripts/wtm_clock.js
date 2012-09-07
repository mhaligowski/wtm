wtm = {
	update: function(ce, perdiodical_executer) {
		var current = (new Date()).getTime();
		var old = Number(ce.readAttribute('data-start'));
		var diff = Math.floor((current - old) / 1000); // seconds only

		var seconds = diff % 60; diff = Math.floor(diff / 60); if (seconds < 10) seconds = "0" + seconds;
		var minutes = diff % 60; diff = Math.floor(diff / 60); if (minutes < 10) minutes = "0" + minutes;
		var hours = diff; if (hours < 10) hours = "0" + hours;

		// update the clock
		ce.update("(" + hours + ":" + minutes + ":" + seconds + ")");
	},

	start_clock : function() {
		// stop the earlier clock
		if (wtm.timer != null) {
			wtm.timer.stop();
		}

		// find the element
		var button_elem = $('wtm-button');

		// the clock must be running
		if (!button_elem.hasClassName('running')) return;

		// find the clock element
		var clock_elem = $('wtm-clock');

		// create the time
		wtm.update(clock_elem);
		wtm.timer = new PeriodicalExecuter(function(pe) { wtm.update(clock_elem, pe); }, 1);

	},
	stop_clock : function() {
		// stop the clock
		if (wtm.timer != null) wtm.timer.stop();

		$('wtm-clock').purge();
	}
}

// at starting the page
Event.observe(window, 'load', function() {
	var elem = $('wtm-clock');
	if (elem != null) {
		wtm.start_clock();
	}
})