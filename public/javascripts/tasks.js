$(function() {
	$('.input_switcher').change(function() {
		var value = $(this).val();
		var parent = $(this).parent().parent();
		
		if (parent.find("." + value).is(":visible")) return;
		
		parent.find("." + "togglable").each(function(index, item) {
			$(item).toggle('fast');
		});
	});
	
	$('#task_cloud_engine_id').fetch_zones_info(true, true);
	$('#task_cloud_engine_id').change(function() {
		$(this).fetch_zones_info(true, true);
	});
	
});
