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

$(function() {
	$.fn.fetch_zones_info = function(zone_names, availability_info) {
		var value = $(this).val();
		if (value == "") return;

		var selected_option = $(this).find("option[value='" + value + "']");

		if (zone_names) {
			// load zone names
			$.get($(selected_option).data("availability-zones-url"), {}, function(data, status, jqXHR) {
				var zones_select = $("#task_task_params_zone_name");
				zones_select.empty();

				$.each(data, function(index, element) {
					zones_select.append($("<option value='" + element +"'>").text(element));
				});
			});
		}

		if (availability_info) {
			// load zones availability info
			$.get($(selected_option).data("availability-zones-info-url"), {}, function(data, status, jqXHR) {
				$(".zones_info_container").html(data);
			}, "HTML");
		}
	}
});
	
function open_help_dialog(context) {
	$(context).dialog("open");
}

