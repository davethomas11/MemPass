$(document).on('submit', '#mempass', function (e) {
	e.preventDefault();

	if ($('#phrase').val()) {

		
		$('#phrase').focus();

		mempass.generate($('#phrase').val(), function(err, result) {
			if (err) {
				console.log(err);
			} else if (result) {

				$('#mempassResult').html("Password Ready").fadeIn();
				$('#mempassResult').attr('mempass', result);
				$('#show').html('Show').fadeIn();
				$('#copyToClipboard').fadeIn();
			}
		});

	}
	

});


