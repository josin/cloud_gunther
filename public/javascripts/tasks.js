$(function() {
	$('.input_switcher').change(function() {
		var value = $(this).val();
		var parent = $(this).parent().parent();
		
		if (parent.find("." + value).is(":visible")) return;
		
		parent.find("." + "togglable").each(function(index, item) {
			$(item).toggle('fast');
		});
	});
	
	$('#task_cloud_engine_id').change(function() {
		var value = $(this).val();
		
		// load zone names
		$.get($(this).data("cloud-engine-zones-url"), { "cloud_engine_id" : value }, function(data, status, jqXHR) {
			var zones_select = $("#task_task_params_zone_name");
			zones_select.empty();

			$.each(data, function(index, element) {
				zones_select.append($("<option value='" + element +"'>").text(element));
			});
		});
		
		// load zones availability info
		$.get($(this).data("cloud-engine-availability-zones-info-url"), { "cloud_engine_id" : value }, function(data, status, jqXHR) {
			$(".zones_info_container").html(data);
		}, "HTML");
	});
	
});
