$(document).ready(function(){
	$('#reader').html5_qrcode(function(data){
		alert(data);
			$('#read').html(data);
		},
		function(error){
			$('#read_error').html(error);
		}, function(videoError){
			$('#vid_error').html(videoError);
		}
	);
});