function update_queues_indicators() {
	$.ajax({
		url: "/dashboard/queues.json",
		type: "GET",
		success: function(data, status, jqXHR) {
			$(data).each(function(index, item) {
				if (item.name == "inputs" || item.name == "outputs") {
					$("#" + item.name + "_queue").find("strong").text(item.messages);
				}
			});
		},
		error: function(jqXHR, status, error) {
			// console.log("Error status:" + status);
			// console.log("Error:" + error);
		}
	});
}

$(function() {
	// update_queues_indicators();
	// setInterval(update_queues_indicators, 5000);
	// $("#cloud_engine").fetch_zones_info(false, true);
	$('#cloud_engine').change(function() {
		$(this).fetch_zones_info(false, true);
	});
	
});
