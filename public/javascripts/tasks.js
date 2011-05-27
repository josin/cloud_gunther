(function($, window, document, undefined) {
	$(function() {
		$('.input_switcher').change(function() {
			var value = $(this).val();
			var parent = $(this).parent().parent();
			
			if (parent.find("." + value).is(":visible")) return;
			
			parent.find("." + "togglable").each(function(index, item) {
				$(item).toggle('fast');
			});
		})
	});
})(jQuery, window, document);
