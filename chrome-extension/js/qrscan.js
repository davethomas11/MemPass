$(document).ready(function () {

	$('#reader').html5_qrcode({

		videoStart : function () {
			alert("Video start");
		},

		qrcodeSuccess : function(data){
			
			alert(data);
			$('#read').html(data);
			
		},

		qrcodeError : function(error){
			
			$('#read_error').html(error);
		}, 

		videoError: function(videoError){
			
			$('#vid_error').html(videoError);
		}

	});
	
});