$(document).ready(function() {
	$("#shorten_form .submit a").attr("href", "#shorten").click(function() {
		$("#shorten_form").submit();
		return false;
	});
	$("#shorten_form").submit(function() {
		var input = $("#shorten_form input[type=text]");
		if ($.trim(input.val()).length == 0) { return false; }
		$.post("/shorten", {url: input.val()}, function(response) {
			input.val(response).select();
		});
		return false;
	});
	$("#new_link_form input[type=text]").focus(function() {
		
	});
});