var wtm = wtm || {};

wtm.format_date = function(d) {
	var year = d.getFullYear();
	var month = d.getMonth() + 1;
	month = month < 10 ? "0" + month : month;

	var day = d.getDate();

	var hour = d.getHours();
	var minute = d.getMinutes();

	return year + "-" + month + "-" + day + " " + hour + ":" + minute;
}

wtm.submit_filter = function() {
	$("wtm_query_form").submit();
}

wtm.edit_time = function(elmt) {
	elmt.observe('click', function(evnt) {
		var c = elmt.previous(0);
		var f = new Element("form").insert(new Element('input', { 
			'type': 'text', 
			'value': c.innerHTML, 
			'name': elmt.up(0).hasClassName('start_time') ? 'start' : 'end'}));
		
		elmt.hide();

		// add the form to the tree
		c.replace(f);

		f.observe('submit', function(evnt_i) {
			evnt_i.stop();
			new Ajax.Request(elmt.href, {
				method: 'put',
				requestHeaders: {Accept: 'text/javascript'},
				parameters: f.serialize(),
				evalJS: 'force'
			});

		});

		// prevent from going to the link
		evnt.stop();
	});	
}

Event.observe(window, 'load', function() {
	$$(".start_time a, .finish_time a").each(function(elmt) {
		wtm.edit_time(elmt);
	});
});