// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){			
	$('textarea').elastic();
	
	$('.help_dialog').dialog({
		width: 500,
		autoOpen: false,	
		position: ['right', 'center'],
	});
});	
	
function open_help_dialog(context) {
	$(context).dialog("open");
}
